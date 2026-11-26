# Hoenn PT-BR — Jo5-k

Mod independente de tradução para **Pokémon Emerald, Ruby e Sapphire** no **G1Recomp**. Versão **0.2.0**, API 2. Não é um patch de ROM para emuladores comuns.

## Android

Importe o ZIP pelo gerenciador de mods do G1Recomp, aceite substituir a versão anterior de **Hoenn - Jo5-k**, ative o mod para o jogo e feche/reabra o jogo. Não é necessário instalar, ativar ou remover o mod de FireRed.

Se o gerenciador não oferecer a substituição, remova somente a versão antiga de **Hoenn - Jo5-k** e importe o novo ZIP. Não apague saves nem reinstale o G1Recomp. O ID continua `hoenn_ptbr_jo5k`, para substituir a instalação anterior.

O ZIP contém `manifest.json`, `main.lua`, `shared.lua`, `hoenn.lua`, `options.lua`, `layout.lua`, `fonts/` e `lang/` na raiz. Não importe o ZIP do mod FRLG como se fosse esta tradução.

## Correção do erro no Android

A versão anterior falhava em `shared.lua:4` com “gerenciador de mods indisponível”, ao acessar `mod.game.mods` para buscar arquivos em outro mod. Esta versão inclui os recursos no próprio pacote e não usa `mod.game`, métodos privados do carregador ou `require` de módulos do motor. Também não exige API 3, recursos externos, permissões internas, arquivos do Windows/Linux ou configuração de caminhos.

## Conteúdo

- Catálogos de diálogos do XML de Emerald em inglês/PT-BR, com verificação do inglês antes da substituição.
- Interface, introdução de Birch, itens, descrições de itens/golpes/habilidades e nomes de golpes.
- Cópias internas dos oito catálogos compatíveis do FRLG PT-BR 0.1.7. O ponto de entrada e os diálogos/endereços de Kanto não são executados.
- Dados de altura/peso por identificador de espécie, sem renumerar Pokémon ou alterar atributos de batalha.
- Nomes das naturezas, habilidades e golpes com opções independentes **PORTUGUÊS / ENGLISH**. Descrições permanecem em português. Reabra o jogo após mudar uma opção.

Os nomes próprios das espécies e seus números originais são preservados. A transferência não trata números internos de FireRed como se fossem os de Emerald: itens, golpes e espécies usam identificadores semânticos existentes no jogo carregado.

## Limites de cobertura

Não é uma tradução comprovada de 100% de cada tela e entrada da Pokédex. Os recursos fornecidos não contêm um catálogo completo de descrições de espécies em português; onde ele não existe, o texto original permanece disponível. Não são inventadas entradas nem apagadas descrições. Os 386 registros de medidas do FRLG não equivalem a 386 descrições de Pokédex traduzidas.

Ruby e Sapphire reutilizam apenas correspondências inglesas seguras. O pacote não usa offsets de Emerald sem confirmar o texto da ROM carregada; diferenças de história/revisão permanecem no idioma original. Cobertura real em ROMs Ruby/Sapphire ainda não foi medida.

## Validação

O carregador atual, sem FRLG instalado, aplica 8.696 substituições de texto de Emerald; aliases entram nessa contagem. A auditoria verifica a largura das linhas desse corpus, reservando espaço para variáveis. Descrições usam limites próprios: habilidades 144 pixels/1 linha, golpes 154 pixels/2 linhas, itens 109 pixels/3 linhas. Foram verificados 411 textos distintos desses contextos, 309 descrições nativas de itens e 400 combinações de Trainer Memo (naturezas PT/EN, nível e local).

A renderização da fonte foi validada com LÖVE e o medidor real do motor. Os testes de opções e diagramação passam em LuaJIT e Lua 5.5. As verificações preservam placeholders, controles e atributos de jogo. O ajuste de diálogo respeita duas linhas visíveis e a rolagem do jogo, sem apagar o restante da fala.

Esses testes verificam o código do carregador Android; não substituem teste visual em um aparelho físico. A versão exata do aplicativo Android do usuário não foi identificada pelo número.

Para reproduzir, consulte `tests/README.md`. A procedência dos catálogos está em `docs/embedded-resources.json`; as contagens dos XMLs estão em `docs/xml-coverage.json`.

## Créditos

Tradução original FRLG: Breno; port/revisão: LordSangreal; tradução, revisão, gráficos e testes: Solid One, conforme créditos do projeto original. XML PT-BR de Emerald: zambrakas, conforme identificação do arquivo fornecido. Integração de Hoenn: Jo5-k. O ZIP espanhol 0.10.1 foi usado como referência de formato, sem incorporar seus catálogos em espanhol neste pacote.

ROMs, saves, APKs e código do motor não são distribuídos. A fonte compacta incluída deriva dos glifos do FRLG PT-BR 0.1.7 e é registrada pela API pública de fontes, sem substituir funções do motor.
