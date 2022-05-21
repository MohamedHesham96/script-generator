<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<div class="modal" id="tableRecordModal" tabindex="-1" aria-labelledby="tableRecordModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Entity data</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                </button>
            </div>
            <div class="modal-body">
                <form id="tableRecordForm">
                    <input type="hidden" id="tableId">
                    <%--                    <div class="mb-3">--%>
                    <%--                        <label for="tableImage" class="form-label">Image</label>--%>
                    <%--                        <input type="file" class="form-control" id="tableImage" aria-describedby="emailHelp">--%>
                    <%--                    </div>--%>
                    <div class="mb-3">
                        <label for="tableName" class="form-label">Name</label>
                        <input class="form-control" id="tableName">
                    </div>
                    <div class="mb-3">
                        <label for="selectScript" class="form-label">Select script</label>
                        <textarea rows="6" class="form-control" id="selectScript"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="deleteScript" class="form-label">Delete script</label>
                        <textarea rows="6" class="form-control" id="deleteScript"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button id="saveButton" type="button" class="btn btn-primary" onclick="saveTableRecord()">
                    Save changes
                </button>
            </div>
        </div>
    </div>
</div>


<script>
    function updateTableRecord(id, name, selectScript, deleteScript) {
        $("#saveButton").attr("onclick", "saveTableRecord(" + true + ")");
        console.log("updateTableRecord: " + id);
        $("#tableId").val(id);
        $("#tableName").val(name);
        $("#selectScript").val(selectScript);
        $("#deleteScript").val(deleteScript);
        $("#tableRecordModal").modal("show");
    }

    function saveTableRecord(isUpdateOperation) {
        var tableName = $("#tableName").val();
        var selectScript = $("#selectScript").val();
        var deleteScript = $("#deleteScript").val();
        if (isUpdateOperation) {
            var tableId = $("#tableId").val();
        }
        const requestBody = {
            id: tableId,
            name: tableName,
            selectScript: selectScript,
            deleteScript: deleteScript
        }
        toastr.options = {
            "closeButton": true,
            "progressBar": true,
            "timeOut": "1500"
        }
        $.ajax({
            url: '/tableRecord',
            method: 'POST',
            data: JSON.stringify(requestBody),
            contentType: "application/json",
            success: function (response) {
                if (response.status == true) {
                    toastr.success("Table has been saved");
                    $("#tableRecordModal").modal("hide");
                    timedRefresh(1500);
                }
            },
            error: function () {
                toastr.error("Failed to save entity data");
                $("#tableRecordModal").modal("hide");
                timedRefresh(1500);
            }
        });
    }
</script>

