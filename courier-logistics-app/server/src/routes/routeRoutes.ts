import { Router } from "express";
import { getAllRoutes } from "../controllers/routeController";

const router = Router();

router.get("/", getAllRoutes);

export default router;
