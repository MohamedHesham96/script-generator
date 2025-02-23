package com.bluesoft.scriptgenerator.DTO;

import lombok.Data;

@Data
public class SearchRequest {
    private String searchText;
    private Boolean searchInQueries;
    private String createdBy;
}
