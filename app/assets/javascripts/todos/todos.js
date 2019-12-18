$( document ).ready(function() {
    $(".markItem").on("click",function () {
        var todo_id = $(this).attr('id');
        var todo_item = $('#todo-item'+todo_id).text();
        console.log("The item text is "+todo_item);
        $.ajax({
            url: "/todos/"+todo_id,
            method: "PUT",
            dataType: 'js',
            // data: {},
            success: function (data,status,jqXHR) {
                console.log(data);
                // alert("The data is "+ data);
                alert("Its working!!");
                // $('body').load( "/todos");
            },
            error: function (error) {
                alert(error);
            }
        });
    });
});






