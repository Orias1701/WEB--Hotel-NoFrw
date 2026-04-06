package controller;

import java.util.List;

import model.VaiTro;
import service.VaiTroService;

public class VaiTroController {
    private final VaiTroService service = new VaiTroService();

    public List<VaiTro> getAll() { return service.getAll(); }
    public boolean add(VaiTro vt) { return service.add(vt); }
    public boolean update(VaiTro vt) { return service.update(vt); }
    public boolean delete(int id) { return service.delete(id); }
}
