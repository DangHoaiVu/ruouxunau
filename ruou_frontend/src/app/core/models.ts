export interface Product {
  id: string; variantId: string; sku: string; slug: string; name: string; category: string; material: string; volume: number; alcohol: number; price: number; comparePrice?: number; stock: number; badge?: string; featured?: boolean; image: string; gallery: string[]; shortDescription: string; description: string; producer: string; origin: string; tastingNotes: string[];
}
export interface Story { id: string; slug: string; title: string; excerpt: string; category: string; image: string; author: string; publishedAt: string; readTime: number; featured?: boolean; content: string[]; }
export interface CartItem { product: Product; quantity: number; }
export interface User { id: string; name: string; email: string; phone?: string | null; role: 'CUSTOMER' | 'ADMIN'; permissions: string[]; }
export interface Order {
  id: string;
  orderNumber: string;
  userId: string;
  customerName: string;
  customerEmail: string;
  customerPhone: string;
  addressDetail: string;
  wardName: string;
  districtName: string;
  provinceName: string;
  customerNote?: string | null;
  subtotal: number;
  shippingFee: number;
  totalAmount: number;
  paymentMethod: 'COD';
  status: 'NEW' | 'CONFIRMED' | 'SHIPPING' | 'COMPLETED' | 'CANCELLED';
  createdAt: string;
  updatedAt: string;
  items: OrderItem[];
}

export interface OrderItem {
  id: string; productId: string; variantId: string; sku: string; productName: string;
  variantLabel: string; imageUrl?: string | null; unitPrice: number; quantity: number; lineTotal: number;
}

export interface CreateOrderPayload {
  items: { variantId: string; quantity: number }[];
  receiverName: string; phone: string; addressDetail: string; wardName: string;
  districtName: string; provinceName: string; note?: string;
}
