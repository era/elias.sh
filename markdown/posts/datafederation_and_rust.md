---
title: Data Federation and Rust
date: 2023-08-29
---

Data federation is an approach that consolidates data from multiple sources into a single, virtual view. This method enables organizations to enhance their data utilization by eliminating data duplication. It’s a hot topic at the moment with companies like Databricks, Starburst, and Cloud Providers (AWS Athena, Redshift Spectrum) trying to sell the solution. But why? 

[Daniel Abadi says in his post about the subject](https://www.starburst.io/blog/data-federation-and-data-virtualization-never-worked-in-the-past-but-now-its-different/) “Thirty years ago it was already commonplace for large businesses to have hundreds — even thousands of different database instances managing data from the variety of different applications running at that business”. This leads to several data silos, making really hard to find answers that need to join different data sources.

One common solution was to build ETL (extract transform load) jobs to centralize all the data into a single data warehouse, such as AWS Redshift (the team I worked when I was Amazon employee :P). This works but adds friction, someone has to maintain and write those jobs and worst: you normally don’t want those jobs running 
all the time, because they may affect the performance of your applications, 
so people normally have batch jobs running at night synchronizing the data from the previous day. In that case, your centralized view is always at least 1 day delayed.

![](/datafederation_and_rust/Untitled.png)

A different approach is to have a data federation system, able to translate user requests into the different data sources. This type of system normally gets very interesting when you need to join data that is silo’ed into different databases.

![](/datafederation_and_rust/Untitled%201.png)

This approach allows us to fetch more “fresh” data since it can be queried where they are stored.

If we open the black-box and assume we are talking about Presto, the overall system looks like this (according to the [Presto paper](https://trino.io/Presto_SQL_on_Everything.pdf)):

![](/datafederation_and_rust/Untitled%202.png)

The coordinator does a lot of hard things, such as the optimizations of the query plan. The optimizer/planner is responsible for transforming the SQL (SQL is a declarative language, so it does not tell HOW things should be executed, but WHAT the user wants) into a executable plan. It will also break the request into smaller tasks and split it between the workers so it can be run in parallel. The interesting part about Presto is that it can return the results as they are ready, instead of waiting for everything before responding to the client.

But we were talking about taking a user request and translating it into the commands of different data sources, so let’s jump into the worker. In order to connect Presto to the rest of the world, you need to implement the [Connector](https://prestodb.io/docs/current/develop/connectors.html) interface. Is the Connector which will help Presto to translate its internal representation to where the data is stored.

Presto is really nice because it allows us to feel like we have a single database to answer all of our questions, even if we are storing data in different places. But wouldn’t be nicer to also query different APIs just as we query different data storage with Presto?

## Querying (almost) everything

There is a very interesting project written in Rust called “[Trustfall](https://github.com/obi1kenobi/trustfall)” which allow users to query (almost) everything. Quoting the GitHub repo:
 "Trustfall is a query engine for querying any kind of data source, from APIs and databases to any kind of files on disk — and even AI models.”.

In order to allow Trustfall to connect to very different data sources, you just need to define the Schema and write an Adapter that will know how to talk with the data source. When the user sends a query, the front end compiles it down to an intermediate representation that is lazily evaluated. As the query is interpreted, the adapter is called to fetch the needed data. [There is a great short talk about it](https://www.hytradboi.com/2022/how-to-query-almost-everything).

![](/datafederation_and_rust/Untitled%203.png)

This approach allows you to do very cool things such as cross-API queries. We can see a demo of a query responding “*Which GitHub Actions are used in projects on the front page of HackerNews with >=10 points?” (which is available on the repo readme)*

![](/datafederation_and_rust/query-demo.gif)

## Rust

I feel like Rust is going to enable many more projects like Trustfall to appear, not only because the safety of the language allows companies to build efficient applications in an easier way than before, but a lot of software engineers that would not look into C/C++ code are now interested on handling this type of problem thanks to the Rust community.

Also, we are living in a world full of interesting data. The size of the data is getting bigger and bigger. 
We cannot afford to keep moving all the data into one place in order to find answers. 
We must optimize our workflow and start 
separating the query engines from the data storages so we can create new workflows.
