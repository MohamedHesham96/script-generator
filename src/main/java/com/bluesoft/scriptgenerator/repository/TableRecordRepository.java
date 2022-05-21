package com.bluesoft.scriptgenerator.repository;

import com.bluesoft.scriptgenerator.entity.TableRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TableRecordRepository extends JpaRepository<TableRecord, Integer> {

    @Query("select t.selectScript from TableRecord t where t.id in (:ids)")
    List<String> getSelectScriptByIds(int[] ids);

    @Query("select t.deleteScript from TableRecord t where t.id in (:ids)")
    List<String> getDeleteScriptByIds(int[] ids);
}
