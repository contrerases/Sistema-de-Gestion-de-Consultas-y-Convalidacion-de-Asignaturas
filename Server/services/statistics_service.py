from fastapi import HTTPException
import mariadb
from crud.statistics import get_general_stats, get_convalidation_stats, get_convalidation_state_stats, get_convalidation_department_stats, get_convalidation_month_stats, get_convalidation_resolution_time_stats, get_workshop_stats, get_activity_stats, get_student_stats
 

def get_general_stats_service():
    try:
        return get_general_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 

def get_convalidation_stats_service():
    try:
        return get_convalidation_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 

def get_convalidation_state_stats_service():
    try:
        return get_convalidation_state_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 

def get_convalidation_department_stats_service():
    try:
        return get_convalidation_department_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 

def get_convalidation_month_stats_service():
    try:
        return get_convalidation_month_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 

def get_convalidation_resolution_time_stats_service():
    try:
        return get_convalidation_resolution_time_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 

def get_workshop_stats_service():
    try:
        return get_workshop_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 

def get_student_stats_service():
    try:
        return get_student_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 

def get_activity_stats_service():
    try:
        return get_activity_stats()
    except mariadb.Error as e:
        raise HTTPException(status_code=500, detail=str(e)) 