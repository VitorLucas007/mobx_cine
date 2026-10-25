/// Os 4 momentos de qualquer tela que carrega dados.
/// As telas usam um `switch` nesse valor para decidir o que desenhar:
/// initial/loading → indicador de carregamento, success → conteúdo, error → botão de tentar de novo.
enum ViewState { initial, loading, success, error }
