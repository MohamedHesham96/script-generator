package com.bluesoft.scriptgenerator.DTO;

import lombok.Data;

@Data
public class Response {

    private Boolean status;
    private Object data;

    public Response(Boolean status, Object data) {
        this.status = status;
        this.data = data;
    }

    public Response(Boolean status) {
        this.status = status;
    }

}
