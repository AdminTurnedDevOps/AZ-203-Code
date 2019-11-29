import azure.batch.batch_service_client as clientAuth
import azure.batch.batch_auth as batchAuth
import azure.batch.models as batchmodels
import azure.batch.models.batch_error
import datetime
import logging

def newBatchJobSchedule(account, key, URL, job_id, pool_id):
    creds = batchAuth.SharedKeyCredentials(account_name=account, key=key)
    client_creds = clientAuth.BatchServiceClient(creds, URL)

    stop_running = input('How many days do you have this job to run for?: ')
    hours = input('How many hours would you like the recurrence interval to be for your schedule?: ')
    time_to_run = datetime.datetime.utcnow() + datetime.timedelta(days=int(stop_running))

    try:
        pool = batchmodels.PoolInformation(pool_id=pool_id)
        jobSpec = batchmodels.JobSpecification(pool_info=pool)
        schedule = batchmodels.Schedule(do_not_run_after=time_to_run, recurrence_interval=datetime.timedelta(hours=int(hours)))
        job = batchmodels.JobScheduleAddParameter(id=job_id, schedule=schedule, job_specification=jobSpec)

        client_creds.job_schedule.add(cloud_job_schedule=job)

    except Exception as e:
        logging.error(msg=e)

newBatchJobSchedule(account=, key=, URL=, job_id=, pool_id=)
