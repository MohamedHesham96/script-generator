package com.bluesoft.scriptgenerator.service;

import com.bluesoft.scriptgenerator.entity.TableRecord;
import com.bluesoft.scriptgenerator.repository.TableRecordRepository;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class TableService {

    @Autowired
    TableRecordRepository tableRecordRepository;
    @Autowired
    private EntityManagerFactory entityManagerFactory;

    public List<String> getCreatedByNames() {
        return tableRecordRepository.getCreatedBy();
    }

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
        return tableRecordRepository.findAllByOrderByName();
    }

    public TableRecord save(TableRecord tableRecord) {
        tableRecord.setName(firstLetterUpperCase(tableRecord.getName()));
        tableRecord.setCreatedBy(firstLetterUpperCase(tableRecord.getCreatedBy()));
        if (tableRecord.getId() == null) {
            tableRecord.setCreatedOn(LocalDateTime.now());
        } else {
            tableRecord.setCreatedOn(tableRecordRepository.getOne(tableRecord.getId()).getCreatedOn());
        }
        tableRecord.setModifiedOn(LocalDateTime.now());
        return tableRecordRepository.save(tableRecord);
    }

    private String firstLetterUpperCase(String term) {
        return term.substring(0, 1).toUpperCase() + term.substring(1);
    }

    public void delete(int tableRecordId) {
        tableRecordRepository.deleteById(tableRecordId);
    }

    public TableRecord getById(int tableRecordId) {
        return tableRecordRepository.findById(tableRecordId).orElseGet(null);
    }

    public List<TableRecord> search(String searchText, Boolean searchInQueries, String createdBy) {
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
        String createdByLikeTerm = createdBy != null && !createdBy.equalsIgnoreCase("All") ? createdBy.toUpperCase() : "%%";
        Predicate createdByPredicate = criteriaBuilder.like(criteriaBuilder.upper(tableRecord.get("createdBy")), createdByLikeTerm);
        criteriaQuery.where(criteriaBuilder.or(predicates.toArray(new Predicate[]{})), createdByPredicate);
        criteriaQuery.orderBy(criteriaBuilder.asc(tableRecord.get("name")));
        Query query = session.createQuery(criteriaQuery);
        return query.getResultList();
    }
}
