$( document ).ready(function() {
    $(".markItem").on("click",function () {
        var todo_id = $(this).attr('id');
        $.ajax({
            url: "/todos/"+todo_id,
            method: "PUT",
            // dataType: "application/json",
            // data: {todo: { isCompleted: true}},
            success: function (data) {
                alert("Its working!!");
                if (data.todo.isCompleted == true){
                    $('#item'+todo_id).css("color", "green");
                }else {
                    $('#item'+todo_id).css("color", "black");
                }
            },
            error: function (error) {
                alert(error);
            }
        });
    });
});




