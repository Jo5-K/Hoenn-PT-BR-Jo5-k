# Hoenn PT-BR — Jo5-k

Mod independente de tradução para Pokémon Emerald, Ruby e Sapphire no G1Recomp. Versão **0.2.1**, API 2. Não é patch de ROM para emuladores comuns.

## Instalação

Importe o ZIP pelo gerenciador de mods, substitua a versão anterior de Hoenn e feche/reabra o jogo. Não requer o mod FireRed. O ID permanece `hoenn_ptbr_jo5k`. Não apague saves nem reinstale o aplicativo.

## Apenas tradução

O mod altera textos e nomes. Não registra telas, janelas, interface de batalha, paletas, imagens de interface ou layouts. Não altera atributos de Pokémon, efeitos de golpes ou propriedades de itens. O motor e o mod FRLG original não são modificados.

A fonte compacta global da versão 0.2.0 foi removida. A fonte ativa mantém seus glifos originais. Um recurso complementar contém exclusivamente **Ã, Õ, ã e õ**, derivados da fonte normal FRLG PT-BR 0.1.7, com o avanço da letra-base na fonte original do Emerald. Os outros acentos, letras, números e símbolos continuam nativos. Se outro mod já registrou uma fonte TTF, Hoenn preserva essa configuração; os acentos nesse caso dependem da cobertura da fonte escolhida pelo outro mod.

Descrições usam os limites das janelas de Hoenn, com redação concisa e quebras por palavras. Diálogos usam a próxima linha e a rolagem nativa; nenhuma palavra é partida em letras. Não se cria uma aba nova nem se deslocam os campos abaixo. Esta versão não reduz dinamicamente a fonte de uma frase: os textos revisados cabem com o tamanho original.

## Conteúdo e opções

- Diálogos do XML inglês/PT-BR de Emerald, com conferência do texto original.
- Tradução dos textos de menus, itens, descrições de golpes/habilidades e nomes. Traduzir um rótulo não substitui sua interface.
- Seis catálogos de texto compatíveis do FRLG PT-BR 0.1.7 incorporados ao próprio pacote. Código gráfico, diálogos de Kanto e medidas de espécies não são incluídos.
- Opções independentes PORTUGUÊS / ENGLISH para nomes de naturezas, habilidades e golpes. Descrições ficam em português. Reabra o jogo ao mudar as opções.
- Correção da associação de descrições TM/HM conforme os índices da ROM, sem perder o índice zero na conversão dos dados.

## Validação e limites

Passam os testes de opções e diagramação em LuaJIT e Lua 5.5. O corpus de Emerald aplica 8.696 substituições (inclui aliases), valida 309 descrições nativas de itens, 411 textos de contextos conhecidos e 400 combinações de Trainer Memo. As verificações preservam controles e variáveis. O teste visual automatizado com o renderizador real compara pixels das letras normais/pequenas antes e depois, confirma que apenas quatro caracteres usam o complemento e mede as descrições.

Não houve teste visual em aparelho Android físico. Valores dinâmicos e fontes/layouts de outros mods podem ter limites diferentes. Ruby/Sapphire reutilizam apenas correspondências inglesas seguras; sua cobertura completa ainda não foi medida. Não há catálogo completo de descrições de espécies na Pokédex em português: entradas sem tradução permanecem disponíveis no idioma original.

Consulte `tests/README.md`, `docs/embedded-resources.json` e `docs/layout-changes.md`.

## Créditos

Tradução FRLG: Breno; port/revisão: LordSangreal; tradução, revisão, gráficos e testes: Solid One, conforme créditos originais. XML PT-BR de Emerald: zambrakas. Integração Hoenn: Jo5-k. Referência: https://github.com/LordSangreal/gen3_frlg_pt-br_mod/releases/tag/v0.1.7 . ROMs, saves, APKs e código do motor não são distribuídos.
