-- CreateEnum
CREATE TYPE "PackageStatus" AS ENUM ('to_be_picked_up', 'picked_up', 'added_to_bag', 'en_route', 'arrived', 'scheduled_for_delivery', 'out_for_delivery');

-- CreateEnum
CREATE TYPE "BagStatus" AS ENUM ('open', 'sealed', 'loaded', 'delivered');

-- CreateEnum
CREATE TYPE "TruckStatus" AS ENUM ('available', 'in_transit', 'maintenance');

-- CreateEnum
CREATE TYPE "TruckScheduleStatus" AS ENUM ('scheduled', 'departed', 'delayed', 'arrived');

-- CreateEnum
CREATE TYPE "RouteStatus" AS ENUM ('active', 'inactive');

-- CreateEnum
CREATE TYPE "Direction" AS ENUM ('north', 'south', 'east', 'west', 'central');

-- CreateTable
CREATE TABLE "regions" (
    "id" SERIAL NOT NULL,
    "region_code" VARCHAR(10) NOT NULL,
    "region_name" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "regions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pincodes" (
    "id" SERIAL NOT NULL,
    "pincode" VARCHAR(10) NOT NULL,
    "city" VARCHAR(100) NOT NULL,
    "region_id" INTEGER NOT NULL,

    CONSTRAINT "pincodes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "packages" (
    "id" SERIAL NOT NULL,
    "tracking_id" UUID NOT NULL,
    "sender_name" VARCHAR(100) NOT NULL,
    "sender_address" TEXT NOT NULL,
    "sender_pincode" VARCHAR(10),
    "receiver_name" VARCHAR(100) NOT NULL,
    "receiver_address" TEXT NOT NULL,
    "receiver_pincode" VARCHAR(10),
    "destination_region_id" INTEGER,
    "current_region_id" INTEGER,
    "weight" DECIMAL(10,2) NOT NULL,
    "status" "PackageStatus" NOT NULL DEFAULT 'to_be_picked_up',
    "current_location" TEXT,
    "delay_reason" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "packages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bags" (
    "id" SERIAL NOT NULL,
    "bag_code" VARCHAR(20) NOT NULL,
    "route_id" INTEGER NOT NULL,
    "status" "BagStatus" NOT NULL DEFAULT 'open',
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "bags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "package_bags" (
    "id" SERIAL NOT NULL,
    "package_id" INTEGER NOT NULL,
    "bag_id" INTEGER NOT NULL,
    "added_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "package_bags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trucks" (
    "id" SERIAL NOT NULL,
    "truck_code" VARCHAR(20) NOT NULL,
    "capacity" INTEGER NOT NULL DEFAULT 10,
    "status" "TruckStatus" NOT NULL DEFAULT 'available',
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "trucks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "truck_schedules" (
    "id" SERIAL NOT NULL,
    "truck_id" INTEGER NOT NULL,
    "route_id" INTEGER NOT NULL,
    "scheduled_departure" TIMESTAMP(6) NOT NULL,
    "actual_departure" TIMESTAMP(6),
    "status" "TruckScheduleStatus" NOT NULL DEFAULT 'scheduled',
    "delay_reason" TEXT,
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "truck_schedules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "routes" (
    "id" SERIAL NOT NULL,
    "route_code" VARCHAR(30) NOT NULL,
    "source_region_id" INTEGER NOT NULL,
    "destination_region_id" INTEGER NOT NULL,
    "direction" "Direction" NOT NULL,
    "status" "RouteStatus" NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "routes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "truck_bags" (
    "id" SERIAL NOT NULL,
    "truck_schedule_id" INTEGER NOT NULL,
    "bag_id" INTEGER NOT NULL,
    "loaded_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "truck_bags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "raw_updates" (
    "id" SERIAL NOT NULL,
    "payload" JSONB NOT NULL,
    "processed" BOOLEAN NOT NULL DEFAULT false,
    "received_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "processed_at" TIMESTAMP(6),

    CONSTRAINT "raw_updates_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "regions_region_code_key" ON "regions"("region_code");

-- CreateIndex
CREATE UNIQUE INDEX "pincodes_pincode_key" ON "pincodes"("pincode");

-- CreateIndex
CREATE INDEX "pincodes_region_id_idx" ON "pincodes"("region_id");

-- CreateIndex
CREATE UNIQUE INDEX "packages_tracking_id_key" ON "packages"("tracking_id");

-- CreateIndex
CREATE INDEX "packages_destination_region_id_idx" ON "packages"("destination_region_id");

-- CreateIndex
CREATE INDEX "packages_current_region_id_idx" ON "packages"("current_region_id");

-- CreateIndex
CREATE INDEX "packages_status_idx" ON "packages"("status");

-- CreateIndex
CREATE UNIQUE INDEX "bags_bag_code_key" ON "bags"("bag_code");

-- CreateIndex
CREATE INDEX "bags_route_id_idx" ON "bags"("route_id");

-- CreateIndex
CREATE INDEX "bags_status_idx" ON "bags"("status");

-- CreateIndex
CREATE INDEX "package_bags_bag_id_idx" ON "package_bags"("bag_id");

-- CreateIndex
CREATE INDEX "package_bags_package_id_idx" ON "package_bags"("package_id");

-- CreateIndex
CREATE UNIQUE INDEX "package_bags_package_id_bag_id_key" ON "package_bags"("package_id", "bag_id");

-- CreateIndex
CREATE UNIQUE INDEX "trucks_truck_code_key" ON "trucks"("truck_code");

-- CreateIndex
CREATE INDEX "truck_schedules_route_id_idx" ON "truck_schedules"("route_id");

-- CreateIndex
CREATE INDEX "truck_schedules_truck_id_idx" ON "truck_schedules"("truck_id");

-- CreateIndex
CREATE INDEX "truck_schedules_scheduled_departure_idx" ON "truck_schedules"("scheduled_departure");

-- CreateIndex
CREATE INDEX "truck_schedules_status_idx" ON "truck_schedules"("status");

-- CreateIndex
CREATE UNIQUE INDEX "routes_route_code_key" ON "routes"("route_code");

-- CreateIndex
CREATE INDEX "routes_source_region_id_idx" ON "routes"("source_region_id");

-- CreateIndex
CREATE INDEX "routes_destination_region_id_idx" ON "routes"("destination_region_id");

-- CreateIndex
CREATE INDEX "routes_status_idx" ON "routes"("status");

-- CreateIndex
CREATE UNIQUE INDEX "routes_source_region_id_destination_region_id_direction_key" ON "routes"("source_region_id", "destination_region_id", "direction");

-- CreateIndex
CREATE INDEX "truck_bags_truck_schedule_id_idx" ON "truck_bags"("truck_schedule_id");

-- CreateIndex
CREATE INDEX "truck_bags_bag_id_idx" ON "truck_bags"("bag_id");

-- CreateIndex
CREATE UNIQUE INDEX "truck_bags_truck_schedule_id_bag_id_key" ON "truck_bags"("truck_schedule_id", "bag_id");

-- CreateIndex
CREATE INDEX "raw_updates_processed_idx" ON "raw_updates"("processed");

-- CreateIndex
CREATE INDEX "raw_updates_received_at_idx" ON "raw_updates"("received_at");

-- AddForeignKey
ALTER TABLE "pincodes" ADD CONSTRAINT "pincodes_region_id_fkey" FOREIGN KEY ("region_id") REFERENCES "regions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "packages" ADD CONSTRAINT "packages_destination_region_id_fkey" FOREIGN KEY ("destination_region_id") REFERENCES "regions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "packages" ADD CONSTRAINT "packages_current_region_id_fkey" FOREIGN KEY ("current_region_id") REFERENCES "regions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bags" ADD CONSTRAINT "bags_route_id_fkey" FOREIGN KEY ("route_id") REFERENCES "routes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package_bags" ADD CONSTRAINT "package_bags_bag_id_fkey" FOREIGN KEY ("bag_id") REFERENCES "bags"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "package_bags" ADD CONSTRAINT "package_bags_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "packages"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "truck_schedules" ADD CONSTRAINT "truck_schedules_route_id_fkey" FOREIGN KEY ("route_id") REFERENCES "routes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "truck_schedules" ADD CONSTRAINT "truck_schedules_truck_id_fkey" FOREIGN KEY ("truck_id") REFERENCES "trucks"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "routes" ADD CONSTRAINT "routes_source_region_id_fkey" FOREIGN KEY ("source_region_id") REFERENCES "regions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "routes" ADD CONSTRAINT "routes_destination_region_id_fkey" FOREIGN KEY ("destination_region_id") REFERENCES "regions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "truck_bags" ADD CONSTRAINT "truck_bags_bag_id_fkey" FOREIGN KEY ("bag_id") REFERENCES "bags"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "truck_bags" ADD CONSTRAINT "truck_bags_truck_schedule_id_fkey" FOREIGN KEY ("truck_schedule_id") REFERENCES "truck_schedules"("id") ON DELETE CASCADE ON UPDATE NO ACTION;
