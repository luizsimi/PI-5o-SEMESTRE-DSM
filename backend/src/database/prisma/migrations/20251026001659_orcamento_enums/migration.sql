/*
  Warnings:

  - You are about to drop the column `classificacao` on the `Orcamento` table. All the data in the column will be lost.
  - You are about to drop the column `pecaDescricao` on the `Orcamento` table. All the data in the column will be lost.
  - You are about to drop the column `pecaValor` on the `Orcamento` table. All the data in the column will be lost.
  - You are about to drop the column `servicoDescricao` on the `Orcamento` table. All the data in the column will be lost.
  - You are about to drop the column `servicoValor` on the `Orcamento` table. All the data in the column will be lost.
  - Added the required column `orcamentoItemId` to the `Orcamento` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `status` on the `Orcamento` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "TipoOrcamento" AS ENUM ('SERVICO', 'PECA');

-- CreateEnum
CREATE TYPE "Status" AS ENUM ('AGUARDANDO', 'EM_MANUTENCAO', 'REJEITADO', 'FINALIZADO', 'CANCELADO');

-- AlterTable
ALTER TABLE "Orcamento" DROP COLUMN "classificacao",
DROP COLUMN "pecaDescricao",
DROP COLUMN "pecaValor",
DROP COLUMN "servicoDescricao",
DROP COLUMN "servicoValor",
ADD COLUMN     "dataCriacao" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "orcamentoItemId" INTEGER NOT NULL,
DROP COLUMN "status",
ADD COLUMN     "status" "Status" NOT NULL;

-- CreateTable
CREATE TABLE "OrcamentoItem" (
    "id" SERIAL NOT NULL,
    "tipoOrcamento" "TipoOrcamento" NOT NULL,
    "orcamentoValor" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "OrcamentoItem_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Orcamento" ADD CONSTRAINT "Orcamento_orcamentoItemId_fkey" FOREIGN KEY ("orcamentoItemId") REFERENCES "OrcamentoItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
