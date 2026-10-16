package com.ruouxunau.catalog.repository;

import com.ruouxunau.catalog.domain.MediaEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MediaRepository extends JpaRepository<MediaEntity, String> {
    Page<MediaEntity> findAllByOrderByCreatedAtDesc(Pageable pageable);
}
