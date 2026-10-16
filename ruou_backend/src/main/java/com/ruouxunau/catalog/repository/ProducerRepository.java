package com.ruouxunau.catalog.repository;

import com.ruouxunau.catalog.domain.ProducerEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProducerRepository extends JpaRepository<ProducerEntity, String> {
    List<ProducerEntity> findAllByDeletedAtIsNullOrderByNameAsc();
    Optional<ProducerEntity> findByIdAndDeletedAtIsNull(String id);
}
