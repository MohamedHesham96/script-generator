package com.bluesoft.scriptgenerator.service;

import com.bluesoft.scriptgenerator.entity.TableRecord;
import com.bluesoft.scriptgenerator.repository.TableRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TableService {

    @Autowired
    TableRecordRepository tableRecordRepository;

    public String generateScript(String scriptType, int[] ids) {
        List<String> scripts;
        if ("select".equalsIgnoreCase(scriptType)) {
            scripts = tableRecordRepository.getSelectScriptByIds(ids);
        } else {
            scripts = tableRecordRepository.getDeleteScriptByIds(ids);
        }
        String generatedScript = "";
        for (String script : scripts) {
            generatedScript += script + "\n\n";
        }
        return generatedScript;
    }

    public List<TableRecord> getAllTables() {
        return tableRecordRepository.findAll();
    }

    public TableRecord save(TableRecord tableRecord) {
        return tableRecordRepository.save(tableRecord);
    }

    public void delete(int tableRecordId) {
        tableRecordRepository.deleteById(tableRecordId);
    }
}
