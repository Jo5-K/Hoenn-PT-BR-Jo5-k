# Ajustes de diagramação — 0.2.0

O pacote anterior tinha os catálogos FRLG 0.1.6, mas não os ajustes de fonte. Esta versão incorpora os catálogos 0.1.7 e deriva uma fonte TTF compacta dos glifos pequenos dessa versão, incluindo os acentos e as larguras corrigidas de m/w. O registro usa exclusivamente a API pública; não depende de outro mod nem altera o motor.

As descrições são revisadas pelo contexto de Hoenn. Não basta copiar a frase de FireRed: a descrição da habilidade em Emerald tem apenas uma linha. Textos mais curtos conservam o efeito descrito. As descrições de máquinas usam o mapeamento TM/HM do próprio Emerald. O Trainer Memo usa modelos próprios com os mesmos campos dinâmicos de natureza, nível, local e cores.

Os diálogos são medidos em pixels na inicialização. Palavras e códigos de controle são preservados; linhas adicionais usam a rolagem nativa. Textos com controles que não possam ser mapeados com segurança permanecem originais. A reparação de caixa corrige acentos internos como nÃo/nÍvel sem mudar MÃE ou nomes iniciados por letra acentuada.

A auditoria automatizada cobre o corpus disponível de Emerald e contextos conhecidos; não comprova todas as combinações de variáveis, telas de outros mods, resoluções ou ROMs Ruby/Sapphire. Não foi feito teste visual em aparelho Android físico. Descrições completas de espécies na Pokédex ainda dependem de um catálogo PT-BR específico.
