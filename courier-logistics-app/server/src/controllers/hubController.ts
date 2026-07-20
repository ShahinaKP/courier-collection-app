import { Request, Response } from "express";
import prisma from "../db/prisma";

export const getHubs = async (req: Request, res: Response): Promise<void> => {
  try {
    const hubs = await prisma.hub.findMany({
      include: {
        region: true,
      },
      orderBy: {
        hub_name: "asc",
      },
    });

    res.json(hubs);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Failed to fetch hubs",
    });
  }
};

export const getHub = async (req: Request, res: Response): Promise<void> => {
  try {
    const hub = await prisma.hub.findUnique({
      where: {
        id: Number(req.params.id),
      },
      include: {
        region: true,
      },
    });

    if (!hub) {
      res.status(404).json({
        error: "Hub not found",
      });
      return;
    }

    res.json(hub);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Failed to fetch hub",
    });
  }
};

export const createHub = async (req: Request, res: Response): Promise<void> => {
  try {
    const { hub_code, hub_name, city, region_id } = req.body;

    const hub = await prisma.hub.create({
      data: {
        hub_code,
        hub_name,
        city,
        region_id: Number(region_id),
      },
      include: {
        region: true,
      },
    });

    res.status(201).json(hub);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Unable to create hub",
    });
  }
};

export const updateHub = async (req: Request, res: Response): Promise<void> => {
  try {
    const hub = await prisma.hub.update({
      where: {
        id: Number(req.params.id),
      },
      data: {
        hub_code: req.body.hub_code,
        hub_name: req.body.hub_name,
        city: req.body.city,
        region_id: Number(req.body.region_id),
      },
      include: {
        region: true,
      },
    });

    res.json(hub);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Unable to update hub",
    });
  }
};

export const deleteHub = async (req: Request, res: Response): Promise<void> => {
  try {
    await prisma.hub.delete({
      where: {
        id: Number(req.params.id),
      },
    });

    res.json({
      message: "Hub deleted successfully",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      error: "Unable to delete hub",
    });
  }
};
