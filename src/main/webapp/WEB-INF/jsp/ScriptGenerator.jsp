<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Script Generator</title>
    <link href="webjars/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="webjars/toastr/2.1.0/toastr.min.css" rel="stylesheet">
</head>
<body>

<svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="exclamation-triangle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"></path>
    </symbol>
</svg>

<div class="container">
    <div class="ml-4 float-end">
        <img height="120" src="images/msales-logo.png" alt="">
    </div>

    <div class="row">
        <div class="alert alert-warning pt-2 pb-2 border-warning mt-3 col-10" role="alert">
            <svg class="bi flex-shrink-0 me-2" width="16" height="16" role="img" aria-label="Warning:">
                <use xlink:href="#exclamation-triangle-fill"></use>
            </svg>
            <strong>Step 1: </strong>
            Please stop apache service
        </div>
        <br>
        <div class="alert alert-warning border-warning pt-2 pb-2 col-10" role="alert">
            <svg class="bi flex-shrink-0 me-2" width="16" height="16" role="img" aria-label="Warning:">
                <use xlink:href="#exclamation-triangle-fill"></use>
            </svg>
            <strong>Step 2: </strong>
            Please make sure that you have backed up the database you are using
            <button class="btn btn-sm btn-success float-end" onclick="generateBackupScript()" style="font-weight: bold">
                Generate backup script
            </button>
        </div>
    </div>

    <div class="row">
        <div class="d-inline-flex align-items-center w-50">
            <label for="database-name" class="w-25"><strong>Database name: </strong></label>
            <input id="database-name" placeholder="" autofocus class="form-control w-75 border-2"
                   style="font-weight: bold">
        </div>

        <div class="d-inline-flex align-items-center w-50">
            <div class="col-2">
                <label><strong>Query type: </strong></label>
            </div>

            <div class="col-2">
                <input id="selectType" name="scriptType" value="select" type="radio" style="cursor: pointer" checked>
                <label for="selectType" style="cursor: pointer">Select</label>
            </div>

            <div class="col-2">
                <input id="deleteType" name="scriptType" value="delete" type="radio" style="cursor: pointer">
                <label for="deleteType" style="cursor: pointer">Delete</label>
            </div>
        </div>
    </div>

    <div class="card mt-3">
        <div class="card-header">
            <strong>Select Database Tables</strong>
            <button class="btn btn-sm btn-outline-success float-end" data-bs-toggle="modal"
                    data-bs-target="#tableRecordModal" onclick="clearForm('tableRecordForm')"
                    style="font-weight: bold">+ Add new entity +
            </button>
        </div>

        <!-- Table Records -->

        <div class="card-body">
            <div class="row">
                <c:forEach items="${tablesList}" var="table" varStatus="loop">
                    <c:if test="${(loop.index + 1) % 4 == 0 || loop.index == 0}">
                    </c:if>
                    <div class="col-3">
                        <input class="form-check-input" type="checkbox" value="${table.id}"
                               id="${table.name}-${table.id}"
                               style="cursor: pointer">
                        <label class="col-9" for="${table.name}-${table.id}" style="cursor: pointer">
                            <strong>${table.name}</strong>
                        </label>
                        <span style="cursor: pointer">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                                 class="bi bi-pencil-square" viewBox="0 0 16 16"
                                 onclick="updateTableRecord('${table.id}')">
                                <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"></path>
                                <path fill-rule="evenodd"
                                      d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"></path>
                           </svg>

                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                                 class="bi bi-trash"
                                 viewBox="0 0 16 16" onclick="deleteConfirmation('${table.id}', '${table.name}')">
                                  <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"></path>
                                  <path fill-rule="evenodd"
                                        d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"></path>
                            </svg>
                      </span>

                        <hr style="height: 0.5px" class="mt-1 mb-2 m-0">
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="row mt-4" style="justify-content: center">
        <a class="btn btn-success col-3" onclick="generateScript()">
            <strong>Generate script</strong>
        </a>
    </div>

    <div class="row mt-4">
        <label for="script" style="font-weight: bold"></label><textarea class="form-control"
                                                                        id="script" rows="8"
                                                                        disabled></textarea>
    </div>

    <div class="row mt-4 mb-4" style="justify-content: center">
        <a class="btn btn-outline-secondary col-2" onclick="copyToClipBoard()">
            <strong><img height="32" src="images/copy-icon.png">Copy to clipboard</strong>
        </a>
    </div>

    <jsp:include page="TableRecordModal.jsp"></jsp:include>
</div>

<script>
    function generateScript() {
        const checkboxes = $("input:checkbox:checked");
        const databaseName = $("#database-name").val();
        let databasePart = "";
        if (databaseName !== "") {
            databasePart = "Use " + databaseName + "\n\n";
        }
        var scriptType = $("input[name='scriptType']:checked").val();
        var tablesIds = [];
        for (var checkbox of checkboxes) {
            tablesIds.push(checkbox.value);
        }
        const requestBody = {
            scriptType: scriptType,
            tablesIds: tablesIds
        }
        $.ajax({
            url: '/script',
            method: 'POST',
            data: JSON.stringify(requestBody),
            contentType: "application/json",
            success: function (response) {
                if (response.status === true) {
                    $("#script").text(databasePart + response.data);
                }
            },
            error: function () {
                $("#script").text("--- Error ---");
            }
        });
    }

    function generateBackupScript() {
        var databaseName = $("#database-name").val();
        var backupScript = "";
        if (databaseName !== "") {
            databasePart = "Use \"" + databaseName + "\"\n";
            backupScript += databasePart;
            backupScript += "GO\nBACKUP DATABASE \"" + databaseName + "\"\nTO DISK" +
                " = 'c:\\" + databaseName + ".bak'\nWITH FORMAT,\n\t" +
                "MEDIANAME = 'SQLServerBackups',\n\tNAME = 'Full Backup of " + databaseName + "';\nGO";
            $("#script").text(backupScript);
        } else {
            $("#database-name").focus();
        }
    }

    function copyToClipBoard() {
        var scriptText = $("#script").text();
        navigator.clipboard.writeText(scriptText);
        toastr.options = {
            "closeButton": true,
            "progressBar": true,
            "timeOut": "2000",
            "positionClass": "toast-bottom-right",
        }
        toastr.success("Copied to clipboard");

    }

    function timedRefresh(timeoutPeriod) {
        setTimeout("location.reload(true);", timeoutPeriod);
    }


    function clearForm(formId) {
        $("#" + formId)[0].reset();
        $("#tableId").val("");
    }

    function deleteTableRecord(tableRecordId) {
        toastr.options = {
            "closeButton": true,
            "progressBar": true,
            "timeOut": "1500"
        }
        $.ajax({
            url: '/tableRecord/' + tableRecordId,
            method: 'DELETE',
            contentType: "application/json",
            success: function (response) {
                if (response.status === true) {
                    toastr.success("Table has been removed");
                    $("#tableRecordModal").modal("hide");
                    timedRefresh(1500);
                }
            },
            error: function () {
                toastr.error("Failed to remove entity data");
                $("#tableRecordModal").modal("hide");
                timedRefresh(1500);
            }
        });
    }

    function deleteConfirmation(tableRecordId, tableRecordName) {
        bootbox.confirm("Are you sure you want to remove this ?", function (result) {
            if (result) {
                deleteTableRecord(tableRecordId);
            }
        });
    }

</script>

<script src="webjars/jquery/3.6.0/jquery.min.js"></script>
<script src="webjars/bootstrap/5.1.3/js/bootstrap.min.js"></script>
<script src="webjars/toastr/2.1.0/toastr.min.js"></script>
<script src="webjars/bootbox/5.5.2/bootbox.js"></script>
<script src=""></script>

</body>
</html>