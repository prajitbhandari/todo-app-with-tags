$( document ).ready(function() {
    $(".markItem").on("click",function () {
        var todo_id = $(this).attr('id');
        // var markedtodo = $('#markedTodos'+todo_id).text();
        // var unmarkedtodo = $('#unmarkedTodos'+todo_id).text();
        $.ajax({
            url: "/todos/"+todo_id,
            method: "PUT",
            // data: {
            //     todos: @todos
            // },
            success: function (data) {
                alert("Its working!!");
                // debugger;
                if (data.todo.isCompleted == true){
                    $('#item'+todo_id).css("color", "green");
                }else {
                    $('#item'+todo_id).css("color", "black");
                }



                // if (($('#item'+todo_id).css("color")) === 'rgb(0, 0, 0)'){
                //     $('#item'+todo_id).css("color", "green");
                // }else {
                //     $('#item'+todo_id).css("color", "black");
                // }

            },
            error: function (error) {
                alert(error);
            }
        });
    });
});




