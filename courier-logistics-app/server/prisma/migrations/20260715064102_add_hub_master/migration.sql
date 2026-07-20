/*
  Warnings:

  - You are about to drop the column `direction` on the `routes` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[source_region_id,destination_region_id]` on the table `routes` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "routes_source_region_id_destination_region_id_direction_key";

-- AlterTable
ALTER TABLE "regions" ALTER COLUMN "region_code" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "routes" DROP COLUMN "direction";

-- DropEnum
DROP TYPE "Direction";

-- CreateTable
CREATE TABLE "hubs" (
    "id" SERIAL NOT NULL,
    "hub_code" TEXT NOT NULL,
    "hub_name" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "region_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "hubs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "hubs_hub_code_key" ON "hubs"("hub_code");

-- CreateIndex
CREATE UNIQUE INDEX "routes_source_region_id_destination_region_id_key" ON "routes"("source_region_id", "destination_region_id");

-- AddForeignKey
ALTER TABLE "hubs" ADD CONSTRAINT "hubs_region_id_fkey" FOREIGN KEY ("region_id") REFERENCES "regions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
