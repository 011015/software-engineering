let rotFlag = true;
let values = [];
$(document).ready(
    $(".icon_arrow").click(function () {
        $(this).toggleClass("icon_arrow_rotate");
        $(".search_content").toggleClass("expanded");
    })
);