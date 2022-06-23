package com.bluesoft.scriptgenerator.DTO;

public class SearchRequest {

    private String searchText;
    private Boolean searchInQueries;

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
}
