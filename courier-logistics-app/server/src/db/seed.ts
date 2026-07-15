import { PrismaClient, Direction, RouteStatus } from "../../generated/prisma";

const prisma = new PrismaClient();

const REGIONS = [
  { region_code: "RG-N", region_name: "North Region" },
  { region_code: "RG-S", region_name: "South Region" },
  { region_code: "RG-E", region_name: "East Region" },
  { region_code: "RG-W", region_name: "West Region" },
  { region_code: "RG-C", region_name: "Central Region" },
];

const PINCODES = [
  { pincode: "110001", city: "Delhi", region_code: "RG-N" },
  { pincode: "110011", city: "Delhi", region_code: "RG-N" },
  { pincode: "122001", city: "Gurgaon", region_code: "RG-N" },
  { pincode: "201301", city: "Noida", region_code: "RG-N" },
  { pincode: "160017", city: "Chandigarh", region_code: "RG-N" },
  { pincode: "226001", city: "Lucknow", region_code: "RG-N" },
  { pincode: "208001", city: "Kanpur", region_code: "RG-N" },
  { pincode: "248001", city: "Dehradun", region_code: "RG-N" },
  { pincode: "250001", city: "Meerut", region_code: "RG-N" },
  { pincode: "141001", city: "Ludhiana", region_code: "RG-N" },
  { pincode: "560001", city: "Bangalore", region_code: "RG-S" },
  { pincode: "560034", city: "Bangalore", region_code: "RG-S" },
  { pincode: "600001", city: "Chennai", region_code: "RG-S" },
  { pincode: "600020", city: "Chennai", region_code: "RG-S" },
  { pincode: "682001", city: "Kochi", region_code: "RG-S" },
  { pincode: "695001", city: "Thiruvananthapuram", region_code: "RG-S" },
  { pincode: "500001", city: "Hyderabad", region_code: "RG-S" },
  { pincode: "530001", city: "Visakhapatnam", region_code: "RG-S" },
  { pincode: "625001", city: "Madurai", region_code: "RG-S" },
  { pincode: "641001", city: "Coimbatore", region_code: "RG-S" },
  { pincode: "700001", city: "Kolkata", region_code: "RG-E" },
  { pincode: "700019", city: "Kolkata", region_code: "RG-E" },
  { pincode: "751001", city: "Bhubaneswar", region_code: "RG-E" },
  { pincode: "781001", city: "Guwahati", region_code: "RG-E" },
  { pincode: "800001", city: "Patna", region_code: "RG-E" },
  { pincode: "834001", city: "Ranchi", region_code: "RG-E" },
  { pincode: "400001", city: "Mumbai", region_code: "RG-W" },
  { pincode: "400069", city: "Mumbai", region_code: "RG-W" },
  { pincode: "411001", city: "Pune", region_code: "RG-W" },
  { pincode: "380001", city: "Ahmedabad", region_code: "RG-W" },
  { pincode: "395001", city: "Surat", region_code: "RG-W" },
  { pincode: "302001", city: "Jaipur", region_code: "RG-W" },
  { pincode: "403001", city: "Goa", region_code: "RG-W" },
  { pincode: "360001", city: "Rajkot", region_code: "RG-W" },
  { pincode: "462001", city: "Bhopal", region_code: "RG-C" },
  { pincode: "452001", city: "Indore", region_code: "RG-C" },
  { pincode: "492001", city: "Raipur", region_code: "RG-C" },
  { pincode: "474001", city: "Gwalior", region_code: "RG-C" },
  { pincode: "440001", city: "Nagpur", region_code: "RG-C" },
  { pincode: "482001", city: "Jabalpur", region_code: "RG-C" },
];

const ROUTES = [
  {
    route_code: "RTE-001",
    source_region_code: "RG-N",
    destination_region_code: "RG-C",
    direction: Direction.south,
  },
  {
    route_code: "RTE-002",
    source_region_code: "RG-C",
    destination_region_code: "RG-S",
    direction: Direction.south,
  },
  {
    route_code: "RTE-003",
    source_region_code: "RG-S",
    destination_region_code: "RG-C",
    direction: Direction.north,
  },
  {
    route_code: "RTE-004",
    source_region_code: "RG-C",
    destination_region_code: "RG-N",
    direction: Direction.north,
  },
  {
    route_code: "RTE-005",
    source_region_code: "RG-W",
    destination_region_code: "RG-C",
    direction: Direction.east,
  },
  {
    route_code: "RTE-006",
    source_region_code: "RG-C",
    destination_region_code: "RG-W",
    direction: Direction.west,
  },
  {
    route_code: "RTE-007",
    source_region_code: "RG-E",
    destination_region_code: "RG-C",
    direction: Direction.west,
  },
  {
    route_code: "RTE-008",
    source_region_code: "RG-C",
    destination_region_code: "RG-E",
    direction: Direction.east,
  },
];

async function main() {
  console.log("Seeding logistics database...");

  for (const r of REGIONS) {
    await prisma.region.upsert({
      where: { region_code: r.region_code },
      update: {},
      create: r,
    });
  }

  for (const p of PINCODES) {
    const region = await prisma.region.findUnique({
      where: { region_code: p.region_code },
    });
    if (!region) continue;
    await prisma.pincode.upsert({
      where: { pincode: p.pincode },
      update: {},
      create: { pincode: p.pincode, city: p.city, region_id: region.id },
    });
  }

  for (const route of ROUTES) {
    const source = await prisma.region.findUnique({
      where: { region_code: route.source_region_code },
    });

    const destination = await prisma.region.findUnique({
      where: { region_code: route.destination_region_code },
    });

    if (!source || !destination) continue;

    await prisma.route.upsert({
      where: {
        route_code: route.route_code,
      },
      update: {},
      create: {
        route_code: route.route_code,
        source_region_id: source.id,
        destination_region_id: destination.id,
        direction: route.direction,
        status: RouteStatus.active,
      },
    });
  }
  const trucks = [
    { truck_code: "TRK-001", capacity: 20 },
    { truck_code: "TRK-002", capacity: 15 },
    { truck_code: "TRK-003", capacity: 10 },
  ];
  for (const t of trucks) {
    await prisma.truck.upsert({
      where: { truck_code: t.truck_code },
      update: {},
      create: t,
    });
  }

  console.log("Seed completed.");
  console.log(
    `  Regions: ${REGIONS.length}, Pincodes: ${PINCODES.length},
    Routes: ${ROUTES.length}, Trucks: ${trucks.length}`,
  );
}

main()
  .catch((e) => {
    console.error(e);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
