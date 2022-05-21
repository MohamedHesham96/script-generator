package com.bluesoft.scriptgenerator.DTO;

public class GenerateScriptRequest {

    private String scriptType;
    private int[] tablesIds;

    public String getScriptType() {
        return scriptType;
    }

    public void setScriptType(String scriptType) {
        this.scriptType = scriptType;
    }

    public int[] getTablesIds() {
        return tablesIds;
    }

    public void setTablesIds(int[] tablesIds) {
        this.tablesIds = tablesIds;
    }
}
