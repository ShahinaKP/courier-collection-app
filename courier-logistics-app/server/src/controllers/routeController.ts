import { Request, Response } from "express";
import prisma from "../db/prisma";

export const getAllRoutes = async (
  req: Request,
  res: Response,
): Promise<void> => {
  try {
    const routes = await prisma.route.findMany({
      include: {
        source_region: true,
        destination_region: true,
      },
    });

    res.json(routes);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
};
