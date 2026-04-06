package controller;

import java.util.List;

import model.LoaiPhong;
import service.LoaiPhongService;

public class LoaiPhongController {

    private LoaiPhongService service = new LoaiPhongService();

    public List<LoaiPhong> getAll() { return service.getAll(); }
    public boolean add(LoaiPhong lp) { return service.add(lp); }
    public boolean update(LoaiPhong lp) { return service.update(lp); }
    public boolean delete(int id) { return service.delete(id); }
}
