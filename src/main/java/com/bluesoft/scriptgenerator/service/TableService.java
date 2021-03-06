package com.bluesoft.scriptgenerator.service;

import com.bluesoft.scriptgenerator.entity.TableRecord;
import com.bluesoft.scriptgenerator.repository.TableRecordRepository;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.LikeExpression;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.ArrayList;
import java.util.List;

@Service
public class TableService {

    @Autowired
    TableRecordRepository tableRecordRepository;
    @Autowired
    private EntityManagerFactory entityManagerFactory;

    public String generateScript(String scriptType, int[] ids) {
        List<String> scripts;
        if ("select".equalsIgnoreCase(scriptType)) {
            scripts = tableRecordRepository.getSelectScriptByIds(ids);
        } else {
            scripts = tableRecordRepository.getDeleteScriptByIds(ids);
        }
        String generatedScript = "";
        for (String script : scripts) {
            generatedScript += script + "\n\n";
        }
        return generatedScript;
    }

    public List<TableRecord> getAllTables() {
        return tableRecordRepository.findAll();
    }

    public TableRecord save(TableRecord tableRecord) {
        return tableRecordRepository.save(tableRecord);
    }

    public void delete(int tableRecordId) {
        tableRecordRepository.deleteById(tableRecordId);
    }

    public TableRecord getById(int tableRecordId) {
        return tableRecordRepository.findById(tableRecordId).orElseGet(null);
    }

    public List<TableRecord> search(String searchText, Boolean searchInQueries) {
        SessionFactory sessionFactory = entityManagerFactory.unwrap(SessionFactory.class);
        Session session = sessionFactory.openSession();
        CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
        CriteriaQuery<TableRecord> criteria = criteriaBuilder.createQuery(TableRecord.class);
        Root<TableRecord> tableRecord = criteria.from(TableRecord.class);
        CriteriaQuery criteriaQuery = criteria.select(tableRecord);
        List<Predicate> predicates = new ArrayList<>();
            String[] tags = searchText.split(",");
            if (!searchInQueries) {
                for (String tag : tags) {
                    predicates.add(criteriaBuilder.like(tableRecord.get("name"), "%" + tag + "%"));
                }
            } else {
                for (String tag : tags) {
                    predicates.add(criteriaBuilder.like(tableRecord.get("name"), "%" + tag + "%"));
                    predicates.add(criteriaBuilder.like(tableRecord.get("selectScript"), "%" + tag + "%"));
                    predicates.add(criteriaBuilder.like(tableRecord.get("deleteScript"), "%" + tag + "%"));
                }
            }
        criteriaQuery.where(criteriaBuilder.or(predicates.toArray(new Predicate[]{})));
        Query query = session.createQuery(criteriaQuery);
        return query.getResultList();
    }
}
