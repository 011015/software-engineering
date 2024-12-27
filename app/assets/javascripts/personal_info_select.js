$(function () {
    $("#mynotice").click(function () {
        $("#mydata-header").removeClass("select-header-active");
        $("#mydata").hide();
        $("#mycollect-header").removeClass("select-header-active");
        $("#mycollect").hide();
        $(this).toggleClass("select-header-active");
        $("#mymessage").toggle();

    });
});