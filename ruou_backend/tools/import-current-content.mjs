// One-time conversion of the approved Angular content into an editable MySQL import.
// This is deliberately not a startup seed. Re-running the SQL fails on stable IDs.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import ts from '../../ruou_frontend/node_modules/typescript/lib/typescript.js';

const root = path.dirname(fileURLToPath(import.meta.url));
const input = path.resolve(root, '../../ruou_frontend/src/app/core/mock-data.ts');
const output = path.resolve(root, '../database/workbench/01_import_approved_content.sql');
const source = ts.createSourceFile(input, fs.readFileSync(input, 'utf8'), ts.ScriptTarget.Latest, true);
const values = new Map();

function literal(node) {
  if (ts.isAsExpression(node) || ts.isParenthesizedExpression(node)) return literal(node.expression);
  if (ts.isStringLiteral(node) || ts.isNoSubstitutionTemplateLiteral(node)) return node.text;
  if (ts.isNumericLiteral(node)) return Number(node.text);
  if (node.kind === ts.SyntaxKind.TrueKeyword) return true;
  if (node.kind === ts.SyntaxKind.FalseKeyword) return false;
  if (ts.isIdentifier(node)) {
    if (!values.has(node.text)) throw new Error(`Unknown reference: ${node.text}`);
    return values.get(node.text);
  }
  if (ts.isArrayLiteralExpression(node)) return node.elements.map(literal);
  if (ts.isObjectLiteralExpression(node)) {
    return Object.fromEntries(node.properties.map(property => {
      if (!ts.isPropertyAssignment(property)) throw new Error('Unsupported property');
      return [property.name.text, literal(property.initializer)];
    }));
  }
  throw new Error(`Unsupported expression: ${node.kind}`);
}

for (const statement of source.statements) {
  if (!ts.isVariableStatement(statement)) continue;
  for (const declaration of statement.declarationList.declarations) {
    values.set(declaration.name.text, literal(declaration.initializer));
  }
}

const products = values.get('PRODUCTS');
const stories = values.get('STORIES');
if (products.length !== 6 || stories.length !== 4) throw new Error('Approved source counts changed; review before importing');

const id = (kind, index) => String(kind).padStart(2, '0') + String(index).padStart(24, '0');
const quote = value => value == null ? 'NULL' : typeof value === 'boolean' ? (value ? '1' : '0')
  : typeof value === 'number' ? String(value)
  : `'${String(value).replaceAll('\\', '\\\\').replaceAll("'", "''").replaceAll('\n', '\\n')}'`;
const slug = text => text.normalize('NFD').replaceAll(/[\u0300-\u036f]/g, '')
  .replaceAll(/[đĐ]/g, 'd').toLowerCase().replaceAll(/[^a-z0-9]+/g, '-').replaceAll(/^-|-$/g, '');
const rows = (table, columns, data) => `INSERT INTO ${table} (${columns.join(', ')}) VALUES\n${data.map(row => `  (${row.map(quote).join(', ')})`).join(',\n')};\n`;

const categories = [...new Set(products.map(product => product.category))];
const producers = [...new Set(products.map(product => product.producer))];
const articleCategories = [...new Set(stories.map(story => story.category))];
const siteImages = [
  ['home.hero', 'https://images.unsplash.com/photo-1609412058473-c199497c3c5d?auto=format&fit=crop&w=2000&q=88', 'Banner trang chủ'],
  ['home.craft', 'https://images.unsplash.com/photo-1536304993881-ff6e9eefa2a6?auto=format&fit=crop&w=1600&q=90', 'Hạt gạo nguyên liệu'],
  ['page.hero', 'https://images.unsplash.com/photo-1516594915697-87eb3b1c14ea?auto=format&fit=crop&w=2000&q=86', 'Ảnh nền trang nội dung'],
  ['auth.visual', 'https://images.unsplash.com/photo-1516594915697-87eb3b1c14ea?auto=format&fit=crop&w=1400&q=85', 'Ảnh trang đăng nhập'],
  ['contact.hero', 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=2000&q=85', 'Ảnh trang liên hệ'],
];
const media = new Map();
function mediaId(url, alt) {
  if (!media.has(url)) media.set(url, { id: id(24, media.size + 1), url, alt });
  return media.get(url).id;
}
products.forEach(product => product.gallery.forEach(url => mediaId(url, product.name)));
stories.forEach(story => mediaId(story.image, story.title));
siteImages.forEach(([, url, alt]) => mediaId(url, alt));

const sql = [
  '-- Run once with MySQL Workbench after Spring Boot has applied schema migration V6.',
  '-- Existing product, article, and media tables must be empty. This file is not a runtime seed.',
  'SET NAMES utf8mb4;',
  'START TRANSACTION;',
  rows('categories', ['id', 'name', 'slug', 'status', 'sort_order'], categories.map((name, i) =>
    [id(20, i + 1), name, slug(name), 'ACTIVE', i + 1])),
  rows('producers', ['id', 'name', 'origin', 'status'], producers.map((name, i) =>
    [id(21, i + 1), name, products.find(product => product.producer === name)?.origin, 'ACTIVE'])),
  rows('media', ['id', 'url', 'mime_type', 'alt_text'], [...media.values()].map(item => {
    const extension = new URL(item.url).pathname.split('.').pop().toLowerCase();
    const mime = extension === 'avif' ? 'image/avif' : extension === 'webp' ? 'image/webp' : 'image/jpeg';
    return [item.id, item.url, mime, item.alt];
  })),
  rows('products', ['id', 'category_id', 'producer_id', 'name', 'slug', 'short_description', 'material', 'badge',
    'featured', 'tasting_notes', 'description', 'origin', 'status', 'primary_media_id'], products.map((product, i) =>
    [id(22, i + 1), id(20, categories.indexOf(product.category) + 1), id(21, producers.indexOf(product.producer) + 1),
      product.name, product.slug, product.shortDescription, product.material, product.badge ?? null,
      !!product.featured, JSON.stringify(product.tastingNotes), product.description, product.origin, 'ACTIVE', mediaId(product.image)])),
  rows('product_variants', ['id', 'product_id', 'sku', 'volume_ml', 'alcohol_percent', 'price', 'compare_price',
    'weight_gram', 'stock_quantity', 'status'], products.map((product, i) =>
    [id(23, i + 1), id(22, i + 1), `RXN-${String(i + 1).padStart(3, '0')}`, product.volume, product.alcohol,
      product.price, product.comparePrice ?? null, 0, product.stock, 'ACTIVE'])),
  rows('product_images', ['product_id', 'media_id', 'sort_order', 'is_primary'], products.flatMap((product, i) =>
    product.gallery.map((url, j) => [id(22, i + 1), mediaId(url), j, j === 0]))),
  rows('article_categories', ['id', 'name', 'slug', 'status', 'sort_order'], articleCategories.map((name, i) =>
    [id(25, i + 1), name, slug(name), 'ACTIVE', i + 1])),
  "SET @admin_id = (SELECT u.id FROM users u JOIN user_roles ur ON ur.user_id = u.id JOIN roles r ON r.id = ur.role_id WHERE r.code = 'ADMIN' ORDER BY u.created_at LIMIT 1);",
  "-- An absent admin causes a foreign-key error and rolls back the import.",
  `INSERT INTO articles (id, author_id, category_id, featured_media_id, title, slug, excerpt, byline,
    reading_minutes, featured, content, status, published_at) VALUES\n${stories.map((story, i) => {
    const [day, month, year] = story.publishedAt.split('.');
    const fields = [id(26, i + 1), null, id(25, articleCategories.indexOf(story.category) + 1), mediaId(story.image),
      story.title, story.slug, story.excerpt, story.author, story.readTime, !!story.featured,
      story.content.join('\n\n'), 'PUBLISHED', `${year}-${month}-${day} 00:00:00`];
    return `  (${fields.map((value, index) => index === 1 ? '@admin_id' : quote(value)).join(', ')})`;
  }).join(',\n')};`,
  rows('site_assets', ['asset_key', 'media_id'], siteImages.map(([key, url]) => [key, mediaId(url)])),
  'COMMIT;',
  '',
].join('\n');

fs.mkdirSync(path.dirname(output), { recursive: true });
fs.writeFileSync(output, sql, 'utf8');
console.log(`Prepared ${products.length} products, ${stories.length} articles, ${media.size} media URLs: ${output}`);
