/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package clases;

import java.sql.Timestamp;

/**
 *
 * @author alumne
 */
public class Video {

    private int id;
    private String title;
    private String description;
    private int durationSeconds;
    private String thumbnailUrl;
    private String mpdPath;
    private int categoryId;
    private Timestamp uploadDate;

    public Video(){
        
    }
    public Video(int id, String title, String description, int durationSeconds, String thumbnailUrl, String mpdPath, int categoryId, Timestamp uploadDate) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.durationSeconds = durationSeconds;
        this.thumbnailUrl = thumbnailUrl;
        this.mpdPath = mpdPath;
        this.categoryId = categoryId;
        this.uploadDate = uploadDate;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public int getDurationSeconds() {
        return durationSeconds;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public String getMpdPath() {
        return mpdPath;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public Timestamp getUploadDate() {
        return uploadDate;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setDurationSeconds(int durationSeconds) {
        this.durationSeconds = durationSeconds;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public void setMpdPath(String mpdPath) {
        this.mpdPath = mpdPath;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }

    public String getFormattedDuration() {
        int hours = durationSeconds / 3600;
        int minutes = (durationSeconds % 3600) / 60;
        int seconds = durationSeconds % 60;
        return String.format("%02d:%02d:%02d", hours, minutes, seconds);
    }

    public String getMpdUrl() {
        return "/video/stream/" + mpdPath;

    }
    
}