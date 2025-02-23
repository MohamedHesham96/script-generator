package com.bluesoft.scriptgenerator.DTO;

import lombok.Data;

@Data
public class GenerateScriptRequest {

    private String scriptType;
    private int[] tablesIds;
}
