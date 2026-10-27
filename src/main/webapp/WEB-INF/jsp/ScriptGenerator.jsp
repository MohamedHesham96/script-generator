<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Script Generator</title>
    <link href="webjars/bootstrap/5.1.3/css/bootstrap.min.css" rel="stylesheet">
    <link href="webjars/toastr/2.1.0/toastr.min.css" rel="stylesheet">
    <link href="css/script-generator.css" rel="stylesheet">
</head>
<body>
<script>
    function searchEnter(event) {
        if (event.keyCode === 13) {
            $("#searchButton").click();
        }
    }
</script>
<svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
    <symbol id="exclamation-triangle-fill" fill="currentColor" viewBox="0 0 16 16">
        <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"></path>
    </symbol>
</svg>

<div class="sg-layout">
    <aside class="sg-side">
        <header class="sg-header">
            <img src="images/msales-logo.png" alt="mSales - Mobilize your Sales force">
            <div>
                <h1>Scripts Generator</h1>
                <p>Choose the entities you need, pick a query type, and generate ready-to-run SQL scripts.</p>
            </div>
        </header>

        <section class="sg-notices" aria-label="Safety checklist">
            <div class="sg-notice sg-notice-critical" role="alert">
                <svg class="sg-notice-icon" role="img" aria-label="Warning">
                    <use xlink:href="#exclamation-triangle-fill"></use>
                </svg>
                <div class="sg-notice-body">
                    <strong>Step 1</strong>
                    Please stop apache service
                </div>
            </div>
            <div class="sg-notice" role="alert">
                <svg class="sg-notice-icon" role="img" aria-label="Warning">
                    <use xlink:href="#exclamation-triangle-fill"></use>
                </svg>
                <div class="sg-notice-body">
                    <strong>Step 2</strong>
                    Please make sure that you have backed up the database you are using
                </div>
                <button type="button" class="btn btn-sm btn-success" onclick="generateBackupScript()">
                    Generate backup script
                </button>
            </div>
        </section>

        <section class="sg-panel sg-config-panel" aria-labelledby="config-title">
            <div class="sg-panel-header">
                <h2 id="config-title">Script configuration</h2>
            </div>
            <div class="sg-panel-body sg-config">
                <div>
                    <label for="database-name" class="sg-field-label">Database name</label>
                    <input id="database-name" placeholder="database name..." class="form-control sg-input">
                </div>

                <div class="sg-config-options">
                    <div>
                        <span class="sg-field-label" id="query-type-label">Query type</span>
                        <div class="btn-group" role="group" aria-labelledby="query-type-label">
                            <input id="selectType" name="scriptType" value="select" type="radio" class="btn-check"
                                   checked>
                            <label for="selectType" class="btn btn-outline-primary">Select</label>

                            <input id="updateType" name="scriptType" value="update" type="radio" class="btn-check">
                            <label for="updateType" class="btn btn-outline-primary">Update</label>

                            <input id="deleteType" name="scriptType" value="delete" type="radio" class="btn-check">
                            <label for="deleteType" class="btn btn-outline-primary">Delete</label>
                        </div>
                    </div>

                    <div>
                        <span class="sg-field-label">Options</span>
                        <input id="withDate" name="scriptType" type="checkbox" class="btn-check">
                        <label for="withDate" class="btn btn-outline-primary">With Date</label>
                    </div>
                </div>
            </div>
        </section>

        <div class="sg-actionbar">
            <span class="sg-selected" aria-live="polite"><strong id="selectedCount">0</strong> selected</span>
            <button type="button" class="btn btn-generate" onclick="checkIsWithDateFlag()">
                Generate script
            </button>
        </div>

        <section class="sg-panel sg-output-panel" aria-labelledby="output-title">
            <div class="sg-panel-header">
                <h2 id="output-title">Generated script</h2>
                <button type="button" class="btn btn-sm btn-outline-secondary d-inline-flex align-items-center gap-2"
                        onclick="copyToClipBoard()">
                    <img class="sg-copy-icon" src="images/copy-icon.png" alt="">Copy to clipboard
                </button>
            </div>
            <div class="sg-panel-body">
                <label for="script" class="visually-hidden">Generated script</label>
                <textarea class="form-control" id="script" rows="8" disabled></textarea>
            </div>
        </section>
    </aside>

    <main class="sg-main">
        <section class="sg-panel sg-scripts-panel" aria-labelledby="scripts-title">
            <div class="sg-panel-header">
                <h2 id="scripts-title">Available Scripts</h2>
                <button type="button" class="btn btn-sm btn-outline-success" data-bs-toggle="modal"
                        data-bs-target="#tableRecordModal" onclick="clearForm('tableRecordForm')">
                    + Add New Entity
                </button>
            </div>
            <div class="sg-panel-body">
                <div class="sg-search">
                    <div class="sg-search-box">
                        <div class="sg-search-field">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                                 viewBox="0 0 16 16" aria-hidden="true" focusable="false">
                                <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"></path>
                            </svg>
                            <label for="searchText" class="visually-hidden">Search</label>
                            <input id="searchText" onkeypress="searchEnter(event)" placeholder="search..." autofocus
                                   class="form-control sg-input">
                        </div>
                        <button id="searchButton" type="button" class="btn btn-primary" onclick="searchForData()">
                            Search
                        </button>
                        <img id="loadingIcon" style="display: none" src="/images/spinner.gif" alt="Loading...">
                    </div>
                    <label class="sg-secondary-option" for="searchInQueries">
                        <input id="searchInQueries" name="scriptType" type="checkbox" class="sg-check">
                        Search in Queries
                    </label>
                </div>

                <div class="sg-chips" role="group" aria-label="Filter by creator">
                    <span class="sg-chips-label">Created By</span>
                    <button type="button" id="All" class="sg-chip active" aria-pressed="true"
                            onclick="setLastSelectCreatedById('All'); searchForData();">All</button>
                    <c:forEach items="${createdByNames}" var="createdBy">
                        <button type="button" id="${createdBy}" class="sg-chip" aria-pressed="false"
                                onclick="setLastSelectCreatedById('${createdBy}'); searchForData()">${createdBy}</button>
                    </c:forEach>
                </div>
            </div>
            <div class="sg-list-scroll" id="tableRecordsListDev" tabindex="0" aria-label="Database scripts list">
                <jsp:include page="tableRecordsList.jsp"/>
            </div>
        </section>
    </main>
</div>

<jsp:include page="TableRecordModal.jsp"></jsp:include>

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
        month = ++month > 9 ? month : "0" + month;
        var day = fullDate.getDate();
        day = day > 9 ? day : "0" + day;
        var houres = fullDate.getHours();
        houres = houres > 9 ? houres : "0" + houres;
        var minutes = fullDate.getMinutes();
        minutes = minutes > 9 ? minutes : "0" + minutes;
        return fullDate.getFullYear() + "-" + month + "-" + day + " " + houres + ":" + minutes + ":00";
    }

    var isWithDate;

    function checkIsWithDateFlag() {
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
        var createdBy = $("#" + lastSelectedCreatedById).text();
        $("#searchButton").hide();
        $("#loadingIcon").show();
        const requestBody = {
            searchText: searchText,
            searchInQueries: searchInQueries,
            createdBy: createdBy
        }
        $.ajax({
            url: '/search',
            method: 'POST',
            data: JSON.stringify(requestBody),
            contentType: "application/json",
            success: function (response) {
                $("#tableRecordsListDev").html(response);
                updateSelectedCount();
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
        toastr.options = {
            "closeButton": true,
            "progressBar": true,
            "timeOut": "2000",
            "positionClass": "toast-bottom-right",
        }
        var copied = function () {
            toastr.success("Copied to clipboard");
        };
        var failed = function () {
            toastr.error("Copy failed, please select the script and press Ctrl+C");
        };
        // navigator.clipboard only exists on HTTPS/localhost; the live site is plain HTTP
        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(scriptText).then(copied, failed);
            return;
        }
        // the #script textarea is disabled, so copy through a temporary one
        var temp = $("<textarea>").val(scriptText)
            .css({position: "fixed", top: 0, left: 0, opacity: 0}).appendTo("body");
        temp[0].select();
        var ok = false;
        try {
            ok = document.execCommand("copy");
        } catch (e) {
            ok = false;
        }
        temp.remove();
        if (ok) {
            copied();
        } else {
            failed();
        }
    }

    function timedRefresh(timeoutPeriod) {
        setTimeout("location.reload(true);", timeoutPeriod);
    }

    function clearForm(formId) {
        $("#" + formId)[0].reset();
        $("#tableId").val("");
        $("#createdOn").text("----");
        $("#modifiedOn").text("----");
        $("#createdBy").removeClass("is-invalid");
        $("#tableName").removeClass("is-invalid");
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

    let lastSelectedCreatedById = 'All';

    function setLastSelectCreatedById(selectedCreatedById) {
        $("#" + lastSelectedCreatedById).removeClass("active").attr("aria-pressed", "false");
        $("#" + selectedCreatedById).addClass("active").attr("aria-pressed", "true");
        lastSelectedCreatedById = selectedCreatedById;
    }

    function updateSelectedCount() {
        $("#selectedCount").text($(".form-check-input:checkbox:checked").length);
    }
</script>
<script src="webjars/jquery/3.6.0/jquery.min.js"></script>
<script src="webjars/bootstrap/5.1.3/js/bootstrap.min.js"></script>
<script src="webjars/toastr/2.1.0/toastr.min.js"></script>
<script src="webjars/bootbox/5.5.2/bootbox.js"></script>
<script>
    $(document).on("change", ".form-check-input:checkbox", updateSelectedCount);
</script>
</body>
</html>