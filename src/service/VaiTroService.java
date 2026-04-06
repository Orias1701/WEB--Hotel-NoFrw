package service;


import java.util.List;

import model.VaiTro;
import repository.VaiTroDAO;

public class VaiTroService {
    private final VaiTroDAO dao = new VaiTroDAO();

    public List<VaiTro> getAll() { return dao.getAll(); }
    public boolean add(VaiTro vt) { return dao.insert(vt); }
    public boolean update(VaiTro vt) { return dao.update(vt); }
    public boolean delete(int id) { return dao.delete(id); }
}
