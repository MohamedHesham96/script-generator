<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<style>
    .text-bold {
        font-weight: bold;
    }
</style>
<div class="modal" id="tableRecordModal" tabindex="-1" aria-labelledby="tableRecordModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Entity data</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                </button>
            </div>

            <div class="modal-body">
                <form id="tableRecordForm">
                    <input type="hidden" id="tableId">
                    <div class="mb-2">
                        <label for="createdBy" class="form-label text-bold">Created by:</label>
                        <input list="nameOptions" class="form-control" id="createdBy" placeholder="Type or select a name...">
                        <datalist id="nameOptions">
                            <option value="Amir_Magdy">
                            <option value="Hesham">
                            <option value="Youssef">
                            <option value="Mohamed_Saber">
                            <option value="Amir_Reda">
                            <option value="Ahmed_Bakr">
                            <option value="Ahmed_Hossam">
                        </datalist>
                    </div>

                    <div class="mb-2">
                        <label for="tableName" class="form-label text-bold">Title</label>
                        <input id="tableName" class="form-control" placeholder="name">
                    </div>
                    <div class="mb-2">
                        <label for="selectScript" class="form-label text-bold">Select script</label>
                        <textarea id="selectScript" rows="5" class="form-control"
                                  placeholder="Select script"></textarea>
                    </div>
                    <div class="mb-2">
                        <label for="updateScript" class="form-label text-bold">Update script</label>
                        <textarea id="updateScript" rows="5" class="form-control"
                                  placeholder="Update script"></textarea>
                    </div>

                    <div class="mb-2">
                        <label for="deleteScript" class="form-label text-bold">Delete script</label>
                        <textarea id="deleteScript" rows="5" class="form-control"
                                  placeholder="Delete script"></textarea>
                    </div>
                    <div>
                        <small for="createdOn" class="text-secondary">Created On:</small>
                        <small id="createdOn" style="font-weight: bold" class="text-secondary"></small>
                        <small for="modifiedOn" class="text-secondary">Modified On:</small>
                        <small id="modifiedOn" style="font-weight: bold" class="text-secondary"></small>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Close</button>
                <button id="saveButton" type="button" class="btn btn-sm btn-primary" onclick="saveTableRecord()">
                    Save changes
                </button>
            </div>
        </div>
    </div>
</div>


<script>
    function updateTableRecord(id) {
        $("#saveButton").attr("onclick", "saveTableRecord(" + true + ")");
        console.log("updateTableRecord: " + id);
        $.ajax({
            url: '/tableRecord/' + id,
            method: 'GET',
            contentType: "application/json",
            success: function (response) {
                var data = response.data;
                $("#tableId").val(data.id);
                $("#createdBy").val(data.createdBy);
                $("#tableName").val(data.name);
                $("#selectScript").val(data.selectScript);
                $("#updateScript").val(data.updateScript);
                $("#deleteScript").val(data.deleteScript);
                $("#createdOn").text(data.createdOn.replaceAll("T", " ").split(".")[0]);
                $("#modifiedOn").text(data.modifiedOn.replaceAll("T", " ").split(".")[0]);
                $("#tableRecordModal").modal("show");
            },
            error: function () {
                toastr.error("Failed to save entity data");
            }
        });


    }

    function saveTableRecord(isUpdateOperation) {
        var tableName = $("#tableName").val();
        var selectScript = $("#selectScript").val();
        var updateScript = $("#updateScript").val();
        var deleteScript = $("#deleteScript").val();
        var createdBy = $("#createdBy").val();
        if (createdBy == "") {
            $("#createdBy").addClass("is-invalid");
        } else {
            $("#createdBy").removeClass("is-invalid");
        }
        if (tableName == "") {
            $("#tableName").addClass("is-invalid");
        } else {
            $("#tableName").removeClass("is-invalid");
        }
        if (isUpdateOperation) {
            var tableId = $("#tableId").val();
        }
        const requestBody = {
            id: tableId,
            name: tableName,
            selectScript: selectScript,
            updateScript: updateScript,
            deleteScript: deleteScript,
            createdBy: createdBy
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

