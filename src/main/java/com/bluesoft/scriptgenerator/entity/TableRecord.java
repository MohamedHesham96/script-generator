package com.bluesoft.scriptgenerator.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
@Table(name = "table_record")
public class TableRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    @Column(name = "name")
    private String name;
    @Column(name = "image_path")
    private String imagePath;
    @Column(name = "select_script")
    private String selectScript;
    @Column(name = "delete_script")
    private String deleteScript;

    public TableRecord() {
    }

    public TableRecord(Integer id, String name, String imagePath, String selectScript, String deleteScript) {
        this.id = id;
        this.name = name;
        this.imagePath = imagePath;
        this.selectScript = selectScript;
        this.deleteScript = deleteScript;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getSelectScript() {
        return selectScript;
    }

    public void setSelectScript(String selectScript) {
        this.selectScript = selectScript;
    }

    public String getDeleteScript() {
        return deleteScript;
    }

    public void setDeleteScript(String deleteScript) {
        this.deleteScript = deleteScript;
    }
}
