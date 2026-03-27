@{
	Done = "Feito."
	Finished = "Terminado."
	PausePrompt = "Pressione qualquer tecla para continuar. . ." # Command prompt style message

	InstallingDependencies = @{
		Default = "Instalando dependencias."

		SubText = "Isso pode levar mais tempo dependendo da sua conexão à internet."
		HaxeWarn = "Tenha certeza que o Haxe está instalado e adicionado corretamente ao PATH."
	}

	NotHaxe = "Haxelib não foi encontrado!`n'%HAXEPATH%' e '%NEKO_INSTPATH%' estão registrados no PATH?"
	GetHaxePath = "Por favor, insira a localização da sua pasta HaxeToolkit."

	InstallingMSVC = @{
		Prompt = "Instalando Microsoft Visual Studio BuildTools (Dependência)"
		ErrorDownload = "O download do VS BuildTools falhou: {0}"
		ErrorPath = "'{0}' não foi encontrado. Retornando..."
	}

	Menu = @{
		Title = "ASTHG Setup"
		Options = @(
			"Instalar dependências padrão",
			"Configurar para Windows",
			"Configurar para MacOS",
			"Configurar para Android",
			"Remover arquivos de setup",
			"Sair"
		)
		Prompt = "Escolha uma opção ({0}/{1})"
		Error = "Opção inválida, tente denovo."
		ErrorOS = "Essa opção está indisponível em seu sistema."
		NotAvailable = "Essa opção foi desativada pois Haxelib não foi encontrado."
	}

	yOption = "s" # 'Yes' option.
	nOption = "n" # 'No' option.

	RemoveSetup = @{
		Dependencies = "Removendo dependências..."
	}

	NotAvailable = "Sinto muito, essa opção não está disponível agora."

	Config = @{
		FailedSave = "Falha ao salvar configuração: {0}"
	}
}