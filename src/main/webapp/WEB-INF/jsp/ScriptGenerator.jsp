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
            <button class="btn btn-sm btn-success float-end pb-0 pt-0 pl-2 pr-2" onclick="generateBackupScript()"
                    style="font-weight: bold">
                Generate backup script
            </button>
        </div>
    </div>

    <div class="row">
        <div class="input-group">
            <label for="database-name" class="list-group-item"><strong>Database name: </strong></label>
            <input id="database-name" placeholder="database name..." class="form-control list-group-item w-25 border-2"
                   style="font-weight: bold">

            <div class="list-group-item">
                <label><strong>Query type: </strong></label>
            </div>

            <div class="list-group-item">
                <input id="selectType" name="scriptType" value="select" type="radio" style="cursor: pointer" checked>
                <label for="selectType" style="cursor: pointer">Select</label>
            </div>

            <div class="list-group-item">
                <input id="deleteType" name="scriptType" value="delete" type="radio" style="cursor: pointer">
                <label for="deleteType" style="cursor: pointer">Delete</label>
            </div>

            <div class="list-group-item">
                <input id="withDate" name="scriptType" type="checkbox" style="cursor: pointer">
                <label for="withDate" style="cursor: pointer; font-weight: bold">With Date</label>
            </div>
        </div>
    </div>

    <div class="row mt-3">
        <div class="input-group">
            <label for="searchText" class="list-group-item"><strong>Search: </strong></label>
            <input id="searchText" placeholder="search..." autofocus class="form-control list-group-item w-25 border-2"
                   style="font-weight: bold">
            <img id="searchButton" style="cursor: pointer" class="list-group-item btn-outline-info" height="44"
                 src="images/search-icon.png" onclick="searchForData()">
            <img id="loadingIcon" style="display: none" src="/images/spinner.gif" class="list-group-item" height="44"/>
            <div class="list-group-item">
                <input id="searchInQueries" name="scriptType" type="checkbox" style="cursor: pointer">
                <label for="searchInQueries" style="cursor: pointer; font-weight: bold">Search in Queries</label>
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
        <div class="card-body" id="tableRecordsListDev">
            <jsp:include page="tableRecordsList.jsp"/>
        </div>
    </div>

    <div class="row mt-4" style="justify-content: center">
        <a class="btn btn-success col-3" onclick="x()">
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

    var dateTimeValue;

    function dateBootBoxPrompt() {
        bootbox.confirm({
            title: "Please select date and time",
            message: 'DateTime <input id="dateValue" class="form-control mt-1" type="datetime-local">',
            callback: function (result) {
                if (result) {
                    var dateInputValue = $("#dateValue").val();
                    if (dateInputValue == "") {
                        $("#dateValue").addClass("border-danger");
                        return false;
                    } else {
                        var fullDate = new Date(dateInputValue);
                        dateTimeValue = formatDate(fullDate);
                        console.log(dateTimeValue);
                        generateScript();
                    }
                }
            }
        });
    }

    function formatDate(fullDate) {
        var month = fullDate.getMonth();
        month = ++month > 10 ? month : "0" + month;
        var day = fullDate.getDate();
        day = day > 10 ? day : "0" + day;
        var houres = fullDate.getHours();
        houres = houres > 10 ? houres : "0" + houres;
        var minutes = fullDate.getMinutes();
        minutes = minutes > 10 ? minutes : "0" + minutes;
        return fullDate.getFullYear() + "-" + month + "-" + day + " " + houres + ":" + minutes + ":00";
    }

    var isWithDate;

    function x() {
        isWithDate = $("#withDate").prop("checked");
        if (isWithDate) {
            dateBootBoxPrompt();
        } else {
            generateScript();
        }
    }

    function generateScript() {
        const checkboxes = $(".form-check-input:checkbox:checked");
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
                    var script = response.data;
                    if (isWithDate) {
                        script = setDatePlaceholder(script);
                    }
                    $("#script").text(databasePart + script);
                }
            },
            error: function () {
                $("#script").text("--- Error, No result ---");
            }
        });
    }

    function searchForData() {
        var searchText = $("#searchText").val();
        var searchInQueries = $("#searchInQueries").prop("checked");
        $("#searchButton").hide();
        $("#loadingIcon").show();
        const requestBody = {
            searchText: searchText,
            searchInQueries: searchInQueries
        }
        $.ajax({
            url: '/search',
            method: 'POST',
            data: JSON.stringify(requestBody),
            contentType: "application/json",
            success: function (response) {
                $("#tableRecordsListDev").html(response);
                $("#loadingIcon").hide();
                $("#searchButton").show();
            },
            error: function () {
                toastr.error("Request failed !");
                timedRefresh(1500);
            }
        });
    }

    function setDatePlaceholder(script) {
        return script.replaceAll(":dateTimeValue", "'" + dateTimeValue + "'");
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
        bootbox.confirm({
            title: "<span class='text-danger'> Remove '" + tableRecordName + "'</span>",
            message: "Are you sure you want to remove '" + tableRecordName + "' ?",
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-danger'
                },
            },
            callback: function (result) {
                if (result) {
                    deleteTableRecord(tableRecordId);
                }
            }
        });
    }
</script>
<script src="webjars/jquery/3.6.0/jquery.min.js"></script>
<script src="webjars/bootstrap/5.1.3/js/bootstrap.min.js"></script>
<script src="webjars/toastr/2.1.0/toastr.min.js"></script>
<script src="webjars/bootbox/5.5.2/bootbox.js"></script>
</body>
</html>