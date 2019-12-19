$( document ).ready(function() {
    $(".markItem").on("click",function () {
        var todo_id = $(this).attr('id');
        // var markedtodo = $('#markedTodos'+todo_id).text();
        // var unmarkedtodo = $('#unmarkedTodos'+todo_id).text();
        // console.log("The item text is "+todo_item);
        $.ajax({
            url: "/todos/"+todo_id,
            method: "PUT",
            success: function (data) {
                alert("Its working!!");
                // debugger;
                if (($('#item'+todo_id).css("color")) === 'rgb(0, 0, 0)'){
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



// if(document.getElementById('item'+todo_id).style.color === 'black'){
//     document.getElementById('item'+todo_id).style.color =  "green"
// }
// else {
//     document.getElementById('item'+todo_id).style.color =  "black"
// }
// debugger;


