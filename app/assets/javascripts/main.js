$(document).ready(function() {
    
    $(".form-group").on('click','.add-categoria', function() {
        
        formGroup = $('<div class="row form-group"><div class="col-sm-offset-2"></div></div>');
        itemLabel = $('<div class="col-sm-4"><label class="control-label"></label></div>');
        itemField = $('<div class="col-sm-2"><input class="form-control" placeholder="valor"></div>');
        itemMax = $('<div class="col-sm-2"><input class="form-control" placeholder="máximo"></div>');
        removeButton = $('<a value="livro" class="remove-categoria btn btn-danger btn-sm"><span class="glyphicon glyphicon-remove"></span></a>');

        itemAttrId = $(this).attr("id");
        itemAttrName = $(this).attr("name");

        itemLabel.children().text($(this).text());
        
        itemField.children().attr("id", itemAttrId);
        itemField.children().attr("name", itemAttrName);

        itemMax.children().attr("id", (itemAttrId + "_max"));
        itemMax.children().attr("name", (itemAttrName.replace("]","_max]")));
        
        formGroup.children().append(itemLabel).append(itemField).append(itemMax).append(removeButton);
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
        itemValue = $(this).attr("value");
        addItemButton = $('<li class="add-categoria"><a></a></li>');
        
        itemAttrId = $(this).parent().find(".col-sm-2:first").children().attr("id");
        itemAttrName = $(this).parent().find(".col-sm-2:first").children().attr("name");
        itemLabel = $(this).siblings(".col-sm-4").text();

        addItemButton.attr("id", itemAttrId);
        addItemButton.attr("name", itemAttrName);
        addItemButton.children().text(itemLabel);
        
        $(this).parents(".grupo").find(".list-categorias").append(addItemButton);  
        
        $(this).parents(".grupo").find(".btn.btn-default.dropdown-toggle").removeClass("disabled");
        
        $(this).parents(".form-group").remove();
        
    });
});