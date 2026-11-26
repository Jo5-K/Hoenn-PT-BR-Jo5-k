# Correção de escopo — 0.2.1

A 0.2.0 registrava uma fonte compacta para todo o alfabeto latino. Isso afetava menus e batalha mesmo sem registrar uma interface nova. A 0.2.1 remove esse recurso: o complemento contém somente Ã/Õ/ã/õ, e a lista `tiles` da API pública preserva todos os demais glifos na fonte ativa. Uma fonte TTF já configurada por outro mod não é substituída.

Os quatro glifos vêm de `latin_normal_fg.png` do FRLG 0.1.7, com baseline original e avanço da letra-base de Emerald. Não se importam as demais letras nem a tabela compacta de espaçamento. A API pública oferece um único tamanho para esses quatro glifos; ela não escolhe variantes normal/pequena por janela. As letras preexistentes de ambas as fontes são preservadas pixel a pixel.

As descrições foram revistas para o tamanho original das letras e para os limites de cada janela. A quebra dos diálogos usa palavras inteiras. Uma palavra isolada maior que a janela não é cortada pelo mod; o corpus verificado não contém esse caso. Não existe redução dinâmica por frase nem uma nova aba nesta versão. Para evitar cortes, os textos dos contextos conhecidos cabem nos espaços existentes.

Foram removidos os catálogos de medidas de espécies e de estrutura do menu inicial, sem uso necessário para a tradução. Os demais catálogos contêm apenas texto. A associação TM/HM foi corrigida: os índices zero do mapa de máquinas e dos nomes de golpes não podem ser descartados ao exportar os dados.

Testes: letras originais normais/pequenas idênticas no renderizador; apenas quatro caracteres elegíveis ao complemento; fonte de outro mod preservada; nenhum registro de interface/batalha/espécies escrito; propriedades nativas de itens preservadas; descrições e Trainer Memo dentro dos limites conhecidos. A compatibilidade visual com outros mods e Android físico ainda precisa de teste no aplicativo.
