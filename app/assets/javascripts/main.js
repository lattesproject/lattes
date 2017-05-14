$(document).ready(function() {
    
    $(".form-group").on('click','.add-categoria', function() {
        
        var formGroup = $('<div class="row form-group"><div class="col-sm-offset-2"></div></div>');
        var itemLabel = $('<div class="col-sm-4"><label class="control-label"></label></div>');
        var itemField = $('<div class="col-sm-2"><input class="form-control" placeholder="valor"></div>');
        var itemMax = $('<div class="col-sm-2"><input class="form-control" placeholder="máximo"></div>');
        var itemButton = $('<a value="livro" class="remove-categoria btn btn-danger btn-sm"><span class="glyphicon glyphicon-remove"></span></a>');

        itemLabel.children().text($(this).text());
        //TODO corrigir atributos id e name
        itemField.children().attr("id", $(this).attr("value"));
        formGroup.children().append(itemLabel).append(itemField).append(itemMax).append(itemButton);
        $(this).parents(".form-group").before(formGroup);
        
        //desabilitar o botão quando não existem opções para adicionar
        if ($(this).parent().children().length == 1){
            $(this).parent().siblings(".btn.btn-default.dropdown-toggle").addClass("disabled");
        }
        
        $(this).remove();
    });
    
    //desabilita o botão adicionar caso ele não tenha opções disponíveis
    $(".list-categorias").each(function(){
        if ($(this).children().length == 0){
            $(this).siblings(".btn.btn-default.dropdown-toggle").addClass("disabled");
        }
    });

    $(".form-horizontal").on('click', '.remove-categoria', function() {
        var itemValue = $(this).attr("value");
        var deleteButton = $('<li class="add-categoria"><a></a></li>');
        var itemLabel = $(this).siblings(".col-sm-4").text();
        deleteButton.attr("value", itemValue);
        deleteButton.children().text(itemLabel);
        $(this).parents(".grupo").find(".list-categorias").append(deleteButton);  
        
        $(this).parents(".grupo").find(".btn.btn-default.dropdown-toggle").removeClass("disabled");
        
        $(this).parents(".form-group").remove();
        
    });
});