#define DEBUG 0
/* ---------------------------ssd cache---------------------------- */
#ifndef _SSD_CACHE_H
#define _SSD_CACHE_H

#include <pthread.h>
#include "global.h"
#include "timerUtils.h"

/* about using 'shmlib' for MULTIUSER*/
#ifdef MULTIUSER
    #define multi_SHM_alloc(shm_name,len)       SHM_alloc(shm_name,len)
    #define multi_SHM_free(shm_name,shm_vir_addr,len)   SHM_free(shm_name,shm_vir_addr,len)
    #define multi_SHM_get(shm_name,len)         SHM_get(shm_name,len)
    #define multi_SHM_lock_n_check(lockname)    SHM_lock_n_check(lockname)
    #define multi_SHM_lock(lockname)            SHM_lock(lockname)
    #define multi_SHM_unlock(lockname)          SHM_unlock(lockname)
    #define multi_SHM_mutex_init(lock)          SHM_mutex_init(lock)
    #define multi_SHM_mutex_lock(lock)          SHM_mutex_lock(lock)
    #define multi_SHM_mutex_unlock(lock)        SHM_mutex_unlock(lock)
#else
    #define multi_SHM_alloc(shm_name,len)       malloc(len)
    #define multi_SHM_free(shm_name,shm_vir_addr,len)   free(shm_vir_addr)
    #define multi_SHM_get(shm_name,len)         NULL// unregister
    #define multi_SHM_lock_n_check(lockname)    0       //0:success, -1:failure.
    #define multi_SHM_lock(lockname)            //
    #define multi_SHM_unlock(lockname)          //
    #define multi_SHM_mutex_init(lock)          //SHM_mutex_init(lock)
    #define multi_SHM_mutex_lock(lock)          //SHM_mutex_lock(lock)
    #define multi_SHM_mutex_unlock(lock)        //SHM_mutex_unlock(lock)
#endif // MULTIUSER

#define bool    unsigned char

#ifdef CACHE_PROPORTIOIN_STATIC
extern double Proportion_Dirty;
#endif // CACHE_PROPORTIOIN_STATIC

typedef struct
{
    off_t	offset;
} SSDBufTag;

typedef struct
{
    long        serial_id;              // the serial number of the descriptor corresponding to SSD buffer.
    long 		ssd_buf_id;				// SSD buffer location in shared buffer
    unsigned 	ssd_buf_flag;
    long		next_freessd;           // to link the desp serial number of free SSD buffer
    SSDBufTag 	ssd_buf_tag;
    pthread_mutex_t lock;               // For the fine grain size
} SSDBufDesp;

typedef struct
{
    long		n_usedssd;			// For eviction
    long		first_freessd;		// Head of list of free ssds
    pthread_mutex_t lock;
} SSDBufDespCtrl;

typedef enum enum_t_vict
{
    ENUM_B_Clean,
    ENUM_B_Dirty,
    ENUM_B_Any
} enum_t_vict;

extern SSDBufDespCtrl  * DespCtrl_Clean,   * DespCtrl_Dirty;//ssd_buf_desp_ctrl;
extern SSDBufDesp      * Desps_Clean,      * Desps_Dirty;

extern int IsHit;
extern microsecond_t msec_r_hdd,msec_w_hdd,msec_r_ssd,msec_w_ssd,msec_bw_hdd;

extern void CacheLayer_Init();
extern void read_block(off_t offset, char* ssd_buffer);
extern void write_block(off_t offset, char* ssd_buffer);
extern void read_band(off_t offset, char* ssd_buffer);
extern void write_band(off_t offset, char* ssd_buffer);
//extern bool isSamebuf(SSDBufTag *, SSDBufTag *);
extern int ResizeCacheUsage();
extern void CopySSDBufTag(SSDBufTag* objectTag, SSDBufTag* sourceTag);
extern long map_strategy_to_cache(int cache_type, long desp_id);
extern void freeSSDBuf(int cache_type, SSDBufDesp* ssd_buf_hdr);

extern void _LOCK(pthread_mutex_t* lock);
extern void _UNLOCK(pthread_mutex_t* lock);

#endif
