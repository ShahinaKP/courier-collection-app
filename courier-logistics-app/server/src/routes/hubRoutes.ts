import { Router } from "express";

import {
  getHubs,
  getHub,
  createHub,
  updateHub,
  deleteHub,
} from "../controllers/hubController";

const router = Router();

router.get("/", getHubs);

router.get("/:id", getHub);

router.post("/", createHub);

router.put("/:id", updateHub);

router.delete("/:id", deleteHub);

export default router;
