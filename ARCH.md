# ARCH — Preencha após refatoração

## Estrutura final (cole a árvore de pastas)

```text
lib/
	app/
		app_root.dart
	core/
		errors/
			app_error.dart
	features/
		todos/
			data/
				datasources/
					todo_local_datasource.dart
					todo_remote_datasource.dart
				models/
					todo_model.dart
				repositories/
					todo_repository_impl.dart
			domain/
				entities/
					todo.dart
				repositories/
					todo_repository.dart
			presentation/
				pages/
					todos_page.dart
				viewmodels/
					todo_viewmodel.dart
				widgets/
					add_todo_dialog.dart
	main.dart
```

## Fluxo de dependências
UI -> ViewModel -> Repository -> (RemoteDataSource, LocalDataSource)

Diagrama do fluxo aplicado no projeto:

```text
TodosPage/AddTodoDialog
				|
				v
		TodoViewModel
				|
				v
 TodoRepositoryImpl (contrato: TodoRepository)
			/         \
		 v           v
TodoRemoteDataSource   TodoLocalDataSource
```

Justificativa da estrutura:
- A feature `todos` concentra tudo que pertence ao caso de uso de TODO, facilitando manutencao e escalabilidade.
- A camada `presentation` contem UI e estado da tela.
- A camada `domain` concentra entidade e contrato do repositorio.
- A camada `data` concentra implementacao de repositorio, acesso HTTP e persistencia local.
- `core` guarda itens compartilhaveis da aplicacao (ex.: erros comuns).

## Decisões
- Onde ficou a validação?
- Onde ficou o parsing JSON?
- Como você tratou erros?

Respostas:
- Validacao: permanece no `TodoViewModel` (`addTodo`) para validar titulo vazio antes de acionar o repositorio.
- Parsing JSON: permanece em `TodoModel.fromJson`, usado pelo `TodoRemoteDataSource`.
- Tratamento de erros:
	- `TodoRemoteDataSource` lanca `Exception` para respostas HTTP fora de 2xx.
	- `TodoViewModel` faz `try/catch`, converte para mensagens de estado (`errorMessage`) e aplica rollback no toggle em caso de falha.
	- O repositorio centraliza o fluxo remoto/local em `fetchTodos` (busca remota e sincroniza `lastSync` local).
