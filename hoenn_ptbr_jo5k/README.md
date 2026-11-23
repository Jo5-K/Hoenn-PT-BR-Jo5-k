# Hoenn PT-BR — Jo5-k

Mod independente de tradução para **Pokémon Emerald, Ruby e Sapphire** no **G1Recomp**. Versão **0.2.0-beta.1**, API 2. Não é um patch de ROM para emuladores comuns.

## Android

Importe o ZIP pelo gerenciador de mods do G1Recomp, aceite substituir a versão anterior de **Hoenn - Jo5-k**, ative o mod para o jogo e feche/reabra o jogo. Não é necessário instalar, ativar ou remover o mod de FireRed.

Se o gerenciador não oferecer a substituição, remova somente a versão antiga de **Hoenn - Jo5-k** e importe o novo ZIP. Não apague saves nem reinstale o G1Recomp. O ID continua `hoenn_ptbr_jo5k`, para substituir a instalação anterior.

O ZIP contém `manifest.json`, `main.lua`, `shared.lua`, `hoenn.lua`, `options.lua` e `lang/` na raiz. Não importe o ZIP do mod FRLG como se fosse esta tradução.

## Correção do erro no Android

A versão anterior falhava em `shared.lua:4` com “gerenciador de mods indisponível”, ao acessar `mod.game.mods` para buscar arquivos em outro mod. Esta versão inclui os recursos no próprio pacote e não usa `mod.game`, métodos privados do carregador ou `require` de módulos do motor. Também não exige API 3, recursos externos, permissões internas, arquivos do Windows/Linux ou configuração de caminhos.

## Conteúdo

- Catálogos de diálogos do XML de Emerald em inglês/PT-BR, com verificação do inglês antes da substituição.
- Interface, introdução de Birch, itens, descrições de itens/golpes/habilidades e nomes de golpes.
- Cópias internas dos oito catálogos compatíveis do FRLG PT-BR 0.1.6. O ponto de entrada e os diálogos/endereços de Kanto não são executados.
- Dados de altura/peso por identificador de espécie, sem renumerar Pokémon ou alterar atributos de batalha.
- Nomes das naturezas, habilidades e golpes com opções independentes **PORTUGUÊS / ENGLISH**. Descrições permanecem em português. Reabra o jogo após mudar uma opção.

Os nomes próprios das espécies e seus números originais são preservados. A transferência não trata números internos de FireRed como se fossem os de Emerald: itens, golpes e espécies usam identificadores semânticos existentes no jogo carregado.

## Limites de cobertura

Não é uma tradução comprovada de 100% de cada tela e entrada da Pokédex. Os recursos fornecidos não contêm um catálogo completo de descrições de espécies em português; onde ele não existe, o texto original permanece disponível. Não são inventadas entradas nem apagadas descrições. Os 386 registros de medidas do FRLG não equivalem a 386 descrições de Pokédex traduzidas.

Ruby e Sapphire reutilizam apenas correspondências inglesas seguras. O pacote não usa offsets de Emerald sem confirmar o texto da ROM carregada; diferenças de história/revisão permanecem no idioma original. Cobertura real em ROMs Ruby/Sapphire ainda não foi medida.

## Validação

O teste isolado com o carregador do APK Android 0.3.96, sem o mod FRLG instalado e sem disponibilizar `mod.game`, aplica 8.688 substituições no corpus de Emerald, 2.461 strings e 975 operações de nomes/descrições. Aliases e operações repetidas entram nessas contagens; elas não são contagens de falas únicas.

Também foram executados o carregador 0.3.97, o teste de exclusão de FireRed e os testes das três opções de idioma. Os testes de opções passam no LuaJIT e no Lua 5.5, incluindo carregamento sem `loadstring`.

Esses testes verificam o código do carregador Android; não substituem teste visual em um aparelho físico. A versão exata do aplicativo Android do usuário não foi identificada pelo número.

Para reproduzir, consulte `tests/README.md`. A procedência dos catálogos está em `docs/embedded-resources.json`; as contagens dos XMLs estão em `docs/xml-coverage.json`.

## Créditos

Tradução original FRLG: Breno; port/revisão: LordSangreal; tradução, revisão, gráficos e testes: Solid One, conforme créditos do projeto original. XML PT-BR de Emerald: zambrakas, conforme identificação do arquivo fornecido. Integração de Hoenn: Jo5-k. O ZIP espanhol 0.10.1 foi usado como referência de formato, sem incorporar seus catálogos em espanhol neste pacote.

Fontes, ROMs, saves, APKs e código do motor não são distribuídos. O pacote preserva as fontes nativas do G1Recomp e não substitui funções do motor.
