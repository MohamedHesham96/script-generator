package com.bluesoft.scriptgenerator.controllers;

import com.bluesoft.scriptgenerator.DTO.GenerateScriptRequest;
import com.bluesoft.scriptgenerator.DTO.Response;
import com.bluesoft.scriptgenerator.entity.TableRecord;
import com.bluesoft.scriptgenerator.service.TableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class MainController {

    @Autowired
    TableService tableService;

    @GetMapping("/")
    public ModelAndView goToHome() {
        ModelAndView homeMV = new ModelAndView("ScriptGenerator");
        List<TableRecord> tablesList = tableService.getAllTables();
        homeMV.addObject("tablesList", tablesList);
        return homeMV;
    }

    @PostMapping("/script")
    public @ResponseBody
    Response goToHome(@RequestBody GenerateScriptRequest generateScriptRequest) {
        String generatedScript = "";
        try {
            generatedScript = tableService.generateScript(generateScriptRequest.getScriptType(), generateScriptRequest.getTablesIds());
            return new Response(true, generatedScript);
        } catch (Exception e) {
            return new Response(false, "--- Error ---");
        }
    }

    @PostMapping("/tableRecord")
    public @ResponseBody
    Response saveTableRecord(@RequestBody TableRecord tableRecord) {
        try {
            tableService.save(tableRecord);
            return new Response(true, tableRecord);
        } catch (Exception e) {
            return new Response(false, "Failed to save entity data");
        }
    }

    @GetMapping("/tableRecord/{tableRecordId}")
    public @ResponseBody
    Response getTableRecord(@PathVariable int tableRecordId) {
        try {
           TableRecord tableRecord =  tableService.getById(tableRecordId);
            return new Response(true, tableRecord);
        } catch (Exception e) {
            return new Response(false, "Failed to save entity data");
        }
    }

    @DeleteMapping("/tableRecord/{tableRecordId}")
    public @ResponseBody
    Response deleteTableRecord(@PathVariable int tableRecordId) {
        try {
            tableService.delete(tableRecordId);
            return new Response(true);
        } catch (Exception e) {
            return new Response(false, "Failed to save entity data");
        }
    }
}
