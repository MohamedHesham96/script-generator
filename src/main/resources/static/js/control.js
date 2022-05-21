function generateScript() {
    var checkboxes = $("input:checkbox:checked");
    var databaseName = $("#database-name").val();
    var scriptType = $("input[name='scriptType']:checked").val();
    var tablesIds = [];
    for (var checkbox of checkboxes) {
        tablesIds.put(checkbox.val());
    }
    var script = "";
    $.ajax({
        url: '/script',
        method: 'GET',
        data: {
            scriptType: scriptType,
            tablesIds: tablesIds
        },
        success: function (response) {
            if (response.status == true) {
                $("#script").text(response.data);
            }
        },
        error: function () {
            $("#script").text("--- Error ---");
        }
    });

    var databasePart = "";
    if (databaseName != "") {
        databasePart = "Use " + databaseName + "\n";
    }
    $("#script").text(databasePart + script);

}


function copyToClipBord() {
    var scriptText = $("#script").text();
    navigator.clipboard.writeText(scriptText);
}

