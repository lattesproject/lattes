jQuery ->
  $('div.tab-content table.table').dataTable
    dom: '<"panel-body form-inline"f>rtip'
    lengthChange: false
    info: false
    sPaginationType: "simple_numbers"
    pageLength: 10
    language: {
      zeroRecords: "Nenhum registro correspondente encontrado"
      search: "_INPUT_"
      searchPlaceholder: "Pesquisar"
      paginate: {
      previous: "Anterior"
      next: "Próxima"
      }
    }