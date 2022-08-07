package com.bluesoft.scriptgenerator.DTO;

public class SearchRequest {

    private String searchText;
    private Boolean searchInQueries;
    private String createdBy;

    public String getSearchText() {
        return searchText;
    }

    public void setSearchText(String searchText) {
        this.searchText = searchText;
    }

    public Boolean getSearchInQueries() {
        return searchInQueries;
    }

    public void setSearchInQueries(Boolean searchInQueries) {
        this.searchInQueries = searchInQueries;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }
}
