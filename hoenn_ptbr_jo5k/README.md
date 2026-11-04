# [PT-BR] Hoenn - Jo5-k — 0.1.0-beta.1

Mod independente de história e diálogos de Emerald, Ruby e Sapphire. Requer G1R 0.3.97+ e **gen3_frlg_pt-br_mod 0.1.6 ou posterior instalado**.

## Separação

O mod oficial de LordSangreal continua original, exclusivo de FireRed/LeafGreen. Este mod não executa seu main.lua, suas features ou seus diálogos. A antiga extensão local FRLG/Hoenn foi separada, não publicada nem enviada novamente ao upstream.

A dependência é de **recursos instalados**, verificada na inicialização. Uma dependência obrigatória convencional do G1R impediria carregar Hoenn porque o fornecedor é incompatível com esses jogos. O campo informativo `resource_dependencies` documenta isso; a verificação efetiva está em shared.lua. O fornecedor pode permanecer desativado em Hoenn: seus arquivos precisam estar presentes. Ausência ou versão antiga geram falha identificada no gerenciador, antes das traduções.

Fontes PNG/larguras, strings compartilhadas, menus START, nomes de golpes, nomes/descrições de itens e medidas da Pokédex são lidos diretamente do fornecedor. Atualizar o FRLG pelo gerenciador e reabrir o jogo atualiza esses recursos em Hoenn; este mod não baixa atualizações sozinho nem contém cópias desses arquivos.

Não se reutilizam índices numéricos de treinadores de FRLG em Hoenn. Somente nomes/textos com correspondência segura são compartilhados. Não se adicionam espécies, habilidades ou mecânicas ausentes do jogo. Não existe no fornecedor atual um catálogo completo independente de naturezas/habilidades/descrições de todas as espécies; os complementos de Hoenn continuam locais. Descrições específicas de cada edição não são confundidas pela posição ou número do texto.

## Tradução própria

`lang/hoenn/catalog_*.lua`: história e diálogos derivados do XML de Emerald, com atribuição a zambrakas, dividido em 21 partes. `ui.lua`, `ui_strings.lua` e `names.lua`: complementos da integração anterior. Créditos dos recursos FRLG: LordSangreal, Breno e Solid One, conforme o README original. Nenhuma ROM ou XML original é distribuído aqui.

Emerald verifica o endereço **e** o texto original. Ruby/Sapphire usam apenas texto original inequívoco, nunca endereços de Emerald. Placeholders e controles nativos são preservados; sem correspondência segura o texto permanece original. Isso não é uma alegação de tradução integral de Ruby/Sapphire.

Nomes de naturezas, habilidades e golpes têm preferência Português/English no gerenciador. As escolhas antigas são migradas na instalação local. Reabrir o jogo aplica a escolha e relê recursos atualizados.

## Integração e restauração

Manifest API 3. A ponte restrita de texto utiliza os acessores IR do próprio carregador, com o dono deste mod, porque a fachada API 3 de strings não representa todos os controles de impressão existentes. As alterações continuam registradas e reversíveis pelo G1R. Essa ponte e a leitura dos recursos instalados exigem `engine_internals`.

Fontes são decodificadas uma vez e disponibilizadas no cache nativo; não há trabalho por quadro. Uma ponte restrita restaura funções/glifos e invalida o cache ao trocar/recarregar o jogo ou sair para o launcher. Se as fontes não puderem ser decodificadas, permanecem nativas e o motivo é registrado no log. Não há alteração de arquivos do motor.

## Limites

A extensão reaproveita traduções existentes, não cria uma tradução completa nova de Ruby/Sapphire. Alguns catálogos do fornecedor são descritos por ele como provisórios; não se certifica aqui a revisão linguística de cada entrada. A API interna usada pela ponte deve ser revista em atualizações grandes do motor. O gerenciador não trata `resource_dependencies` como dependência convencional: a ausência é detectada pelo próprio mod.
